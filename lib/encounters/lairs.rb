require_relative '../data/lairs_data'
require_relative 'encounters'
require_relative '../data/xp_difficulty_table'

class Lairs
  include LairsData
  include XpDifficultyTable
  AVAILABLE_ENCOUNTER_LEVEL = REVERSED_XP_DIFFICULTY_TABLE.keys

  def initialize
    @encounters = Encounters.new
  end

  # encounter_level : :easy, :medium, :hard, :deadly
  def get_party_encounter( encounter_level, heros_levels )
    raise 'Empty party is not valid. Please provide at least one hero' if heros_levels.empty?

    raise "Bad encounter level : #{encounter_level.inspect}. Available encounter level : #{AVAILABLE_ENCOUNTER_LEVEL.inspect}" unless AVAILABLE_ENCOUNTER_LEVEL.include?( encounter_level )
    raise 'Party too weak. Minimum 3 members' if heros_levels.count < 3

    heros_levels.each do |level|
      raise "Hero level should be an integer currently : #{level.class.to_s}" unless level.class == Integer
      raise "Bad hero level : #{level}. Should be between 1 .. 20" if level < 1 || level > 20
    end

    party_xp_level = heros_levels.map{ |hl| XP_DIFFICULTY_TABLE[hl][encounter_level] }.reduce(&:+)
    get_available_lairs( party_xp_level )
  end

  private

  def get_available_lairs( party_xp_level )
    LAIRS_DATA[:by_xp_lair].select{ |k, v| k >= party_xp_level*0.6 && k <= party_xp_level*1.2 }.values.flatten.uniq
  end



end