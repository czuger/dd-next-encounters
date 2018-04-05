require_relative '../data/encounters_data'
require_relative '../data/xp_difficulty_table'
require_relative '../../lib/monsters/monsters_manual'
require_relative 'encounter'

class Encounters

  include EncountersData
  include XpDifficultyTable
  AVAILABLE_ENCOUNTER_LEVEL = REVERSED_XP_DIFFICULTY_TABLE.keys

  def initialize
    @monster_manual = MonstersManual.new
    @monster_manual.load

    @encounters = {}
    @by_monster_encounters = {}
    ENCOUNTERS.each do |e|
      encounter = Encounter.new( @monster_manual.get( e[:monster_key] ), e[:amount], e[:id], e[:xp_value] )
      @encounters[e[:id]] = encounter
      @by_monster_encounters[e[:monster_key]] ||= []
      @by_monster_encounters[e[:monster_key]] << encounter
    end

    # pp @by_monster_encounters

    @by_xp_encounters = {}
    BY_XP_ENCOUNTERS.each do |k, v|
      @by_xp_encounters[ k ] = v.map{ |e| @encounters[e] }
    end
  end

  # encounter_level : :easy, :medium, :hard, :deadly
  def get_party_encounter( encounter_level, *hero_level )
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

  def by_monster( monster_key )
    @by_monster_encounters[monster_key]
  end

  private

  def get_encounter( min_xp, max_xp )
    raise 'Encounters not loaded' unless @by_xp_encounters
    encounters = @by_xp_encounters.map{ |k_value, encounters| encounters if k_value <= max_xp && k_value >= min_xp }
    encounters = encounters.compact.flatten
    # p encounters.map{ |e| e.to_s }
    encounters.sample
  end

end