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
  end

  def by_id( encounter_id )
    @encounters[ encounter_id ]
  end

  def by_monster( monster_key )
    @by_monster_encounters[monster_key]
  end

end