require_relative 'encounter'
require_relative '../data/xp_difficulty_table'

class Lair

  include XpDifficultyTable

  AVAILABLE_ENCOUNTER_LEVEL=[ :easy, :medium, :hard, :deadly ]

  def initialize( *encounters_types )
    @monster_manual = MonstersManual.new
    @monsters = nil
    @xp_difficulty_table = XP_DIFFICULTY_TABLE
    @encounters_types = encounters_types
    @encounters={}
  end

  def read_manuals
    read_monster_manual
  end

  def groups
    @monster_manual.validate_loaded
    @monster_manual.groups.keys
  end

  # encounter_level : :easy, :medium, :hard, :deadly
  def get_encounter( encounter_level, *hero_level )
    @monster_manual.validate_loaded

    raise "Bad encounter level : #{encounter_level.inspect}. Available encounter level : #{AVAILABLE_ENCOUNTER_LEVEL.inspect}" unless AVAILABLE_ENCOUNTER_LEVEL.include?( encounter_level )
    party_xp_level = hero_level.map{ |hl| @xp_difficulty_table[hl][encounter_level] }.reduce(&:+)

    encounter = Encounter.new( party_xp_level )

    # Choose a random encounter type
    encounter_type = @encounters_types.sample
    bosses = @encounters[encounter_type][:bosses]
    troops = @encounters[encounter_type][:troops]

    # Choose a random boss
    boss = bosses.sample if !bosses.empty? && rand( 1 .. 2 ) == 1
    encounter.add_monster_if_possible( boss ) if boss

    # Choose a random monster
    monster = get_corresponding_monsters( troops, party_xp_level ).sample

    loop do
      break unless encounter.add_monster_if_possible( monster )
    end

    encounter
  end

  private

  def get_corresponding_monsters( troops, party_xp_level)
    troops.map{ |m| m if m.xp_value < party_xp_level }.compact
  end

  def read_monster_manual
    @monster_manual.load
    validate_encounters_types

    @monsters = @monster_manual.select( sources: [ 'Basic Rules', 'Monster Manual' ] )

    @encounters_types.each do |encounter_type|
      @encounters[encounter_type] ||= { troops: [], bosses: [] }
      @encounters[encounter_type][:troops] = @monster_manual.groups[encounter_type]&.troops
      @encounters[encounter_type][:bosses] = @monster_manual.groups[encounter_type]&.bosses
    end
  end

  private

  def validate_encounters_types
    @encounters_types.each do |encounter_type|
      unless @monster_manual.groups.include?( encounter_type )
        raise "Bad lair type : #{encounter_type.inspect}" + ". Available lairs types : #{@monster_manual.groups.keys}"
      end
    end
    @encounters_types =  @monster_manual.groups.keys if @encounters_types.empty?
  end

end

