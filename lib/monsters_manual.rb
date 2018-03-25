require 'yaml'
require_relative 'monster'

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
    @sources[monster.source] << monster

    @challenges[monster.challenge] ||= []
    @challenges[monster.challenge] << monster

    @types[monster.type] ||= []
    @types[monster.type] << monster

    monster.groups.each do |group|
      @groups[group] ||= { troops: [], bosses: [] }
      @groups[group][ :troops ] << monster unless monster.boss
      @groups[group][ :bosses ] << monster if monster.boss
    end
  end

end