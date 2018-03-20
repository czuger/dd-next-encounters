require 'yaml'
require_relative 'monster'

class MonstersManual

  def initialize
    @monsters = {}
    @sources = {}
    @challenges = {}
    @types = {}
  end

  def read
    monsters = YAML::load_file('db/monsters.yml')
    monster_id = 0
    monsters.each do |monster|
      @monsters[monster_id]=monster

      @sources[monster.source] ||= []
      @sources[monster.source] << monster_id

      @challenges[monster.challenge] ||= []
      @challenges[monster.challenge] << monster_id

      @types[monster.type] ||= []
      @types[monster.type] << monster_id

      monster_id+=1
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
    sources_ids = ( sources == :all ? @sources.values.flatten : sources.map{ |s| @sources[s] }.flatten )
    types_ids = ( types == :all ? @types.values.flatten : types.map{ |t| @types[t] }.flatten )
    monsters_ids = sources_ids & types_ids
    monsters_ids.map{ |m| @monsters[m] }
  end
end