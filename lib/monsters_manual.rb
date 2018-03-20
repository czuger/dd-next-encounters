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

end