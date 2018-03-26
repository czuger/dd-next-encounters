require 'yaml'
require_relative 'monster'
require_relative 'monsters_group'

class MonstersManual

  attr_reader :monsters, :groups

  def initialize
    @monsters = {}
    @sources = {}
    @challenges = {}
    @types = {}
    @groups = {}
  end

  def load
    monster_manual = YAML::load_file('db/monsters_manual.yml')
    @monsters = monster_manual[:monsters]
    @sources = monster_manual[:sources]
    @challenges = monster_manual[:challenges]
    @types = monster_manual[:types]
    @groups = monster_manual[:groups]
  end

  def save( filename )
    monster_manual = {
        monsters: @monsters,
        sources: @sources,
        challenges: @challenges,
        types: @types,
        groups: @groups
    }
    File.open( filename, 'w' ){ |f| f.write monster_manual.to_yaml }
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