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
    monsters.each do |monster|
      @monsters[monster.key]=monster

      @sources[monster.source] ||= []
      @sources[monster.source] << monster.key

      @challenges[monster.challenge] ||= []
      @challenges[monster.challenge] << monster.key

      @types[monster.type] ||= []
      @types[monster.type] << monster.key
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

    challenges = @challenges.keys
    challenges.reject!{ |c| c > max_challenge } if max_challenge != :none
    challenges.reject!{ |c| c < min_challenge } if min_challenge != :none
    challenges_ids = challenges.map{ |c| @challenges[ c ] }.flatten

    monsters_ids = sources_ids & types_ids & challenges_ids
    monsters_ids.map{ |m| @monsters[m] }
  end
end