require_relative '../data/by_xp_encounters'
require_relative '../data/xp_difficulty_table'
require_relative 'encounter'

class Encounters

  include ByXpEncounters
  include XpDifficultyTable
  AVAILABLE_ENCOUNTER_LEVEL = REVERSED_XP_DIFFICULTY_TABLE.keys
  @@by_xp_encounters = nil

  # encounter_level : :easy, :medium, :hard, :deadly
  def self.get_party_encounter( encounter_level, *hero_level )
    raise 'Empty party is not valid. Please provide at least one hero' if hero_level.empty?

    raise "Bad encounter level : #{encounter_level.inspect}. Available encounter level : #{AVAILABLE_ENCOUNTER_LEVEL.inspect}" unless AVAILABLE_ENCOUNTER_LEVEL.include?( encounter_level )
    raise 'Party too weak. Minimum 3 members' if hero_level.count < 3

    hero_level.each do |level|
      raise "Hero level should be an integer currently : #{level.class.to_s}" unless level.class == Integer
      raise "Bad hero level : #{level}. Should be between 1 .. 20" if level < 1 || level > 20
    end

    party_xp_level = hero_level.map{ |hl| XP_DIFFICULTY_TABLE[hl][encounter_level] }.reduce(&:+)

    get_encounter( party_xp_level*0.6, party_xp_level*1.2 )
  end


  def self.get_encounter( min_xp, max_xp )
    raise 'Encounters not loaded' unless @@by_xp_encounters
    encounters = @@by_xp_encounters.map{ |k_value, encounters| encounters if k_value <= max_xp && k_value >= min_xp }
    encounters = encounters.compact.flatten
    p encounters.map{ |e| e.to_s }
    encounters.sample
  end

  def self.load_by_xp_encounters( monster_manual )
    @@by_xp_encounters = {}
    BY_XP_ENCOUNTERS.each do |k, v|
      @@by_xp_encounters[ k ] = v.map{ |e| Encounter.new( monster_manual.get( e[:monster_key] ), e[:amount] ) }
    end
  end

end