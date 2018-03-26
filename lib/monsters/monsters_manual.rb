require 'json'
require 'pp'
require_relative 'monster'
require_relative 'monsters_group'
require_relative '../../lib/data/monsters_manual_content'

class MonstersManual

  attr_reader :monsters, :groups

  include MonstersManualContent

  def initialize
    @monsters = {}
    @sources = {}
    @challenges = {}
    @types = {}
    @groups = {}
  end

  def load
    @monsters = {}
    MONSTERS_MANUAL_CONTENT[:monsters].each do |m|
      monster = Monster.new( m[:challenge], m[:name], m[:type], m[:source] )
      monster.xp_value = m[:xp_value]
      monster.boss = m[:boss]
      @monsters[ monster.key ] = monster
    end

    @sources = MONSTERS_MANUAL_CONTENT[:sources]
    @challenges = MONSTERS_MANUAL_CONTENT[:challenges]
    @types = MONSTERS_MANUAL_CONTENT[:types]
    @groups = nil # Hash[ MONSTERS_MANUAL_CONTENT[:groups].map{ |k, g| [ k, g.from_hash( g ) ] } ]
  end

  def save( filename )
    monster_manual = {
        monsters: @monsters.map{ |_, m| m.to_hash },
        sources: @sources,
        challenges: @challenges,
        types: @types,
        groups: Hash[ @groups.map{ |k, g| [ k, g.to_hash ] } ]
    }
    File.open( filename, 'w' ) do |f|
      f.puts 'module MonstersManualContent'
      f.puts "\t MONSTERS_MANUAL_CONTENT = "
      PP.pp(monster_manual,f)
      f.puts 'end'
    end
  end

  def sources
    @sources.keys.sort
  end

  def challenges
    @challenges.keys.sort
  end

  def types
    @types.keys.sort
  end

  def select( sources: :all, types: :all, min_challenge: :none, max_challenge: :none )
    validate_loaded

    sources_ids = ( sources == :all ? @sources.values.flatten : sources.map{ |s| @sources[s] }.flatten )
    types_ids = ( types == :all ? @types.values.flatten : types.map{ |t| @types[t] }.flatten )

    challenges = @challenges.keys
    challenges.reject!{ |c| c > max_challenge } if max_challenge != :none
    challenges.reject!{ |c| c < min_challenge } if min_challenge != :none
    challenges_ids = challenges.map{ |c| @challenges[ c ] }.flatten

    monsters_ids = sources_ids & types_ids & challenges_ids
    monsters_ids.map{ |m| @monsters[m] }
  end

  def add_monster( monster )
    @monsters[monster.key]=monster

    @sources[monster.source] ||= []
    @sources[monster.source] << monster.key

    @challenges[monster.challenge] ||= []
    @challenges[monster.challenge] << monster.key

    @types[monster.type] ||= []
    @types[monster.type] << monster.key

    monster.groups.each do |group|
      @groups[group] ||= MonstersGroup.new
      @groups[group].add_monster( monster )
    end
  end

  def validate_loaded
    raise 'Monster manual not loadad' if @monsters.empty?
  end

end