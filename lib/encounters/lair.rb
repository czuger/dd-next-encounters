require_relative 'encounter'
require_relative '../data/xp_difficulty_table'

class Lair

  include XpDifficultyTable

  AVAILABLE_ENCOUNTER_LEVEL=[ :easy, :medium, :hard, :deadly ]

  def initialize( *encounters_types )
    @monster_manual = MonstersManual.new
    @monsters = nil
    @xp_difficulty_table = XP_DIFFICULTY_TABLE
    # No more used, have to remove it after dependency check
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
    raise 'Empty party is not valid. Please provide at least one hero' if hero_level.empty?
    @monster_manual.validate_loaded

    raise "Bad encounter level : #{encounter_level.inspect}. Available encounter level : #{AVAILABLE_ENCOUNTER_LEVEL.inspect}" unless AVAILABLE_ENCOUNTER_LEVEL.include?( encounter_level )
    raise 'Party too weak. Minimum 3 members' if hero_level.count < 3

    hero_level.each do |level|
      raise "Hero level should be an integer currently : #{level.class.to_s}" unless level.class == Integer
      raise "Bad hero level : #{level}. Should be between 1 .. 20" if level < 1 || level > 20
    end

    party_xp_level = hero_level.map{ |hl| @xp_difficulty_table[hl][encounter_level] }.reduce(&:+)
    sixth_party_xp_level = party_xp_level / 6

    tested_encounters_types = []
    encounter = nil
    loop do

      raise "Can't create an encounter for this party" if (@encounters_types-tested_encounters_types).empty?
      encounter = Encounter.new( party_xp_level )

      # Choose a random encounter type
      encounter_type = ( @encounters_types - tested_encounters_types ).sample
      bosses = @encounters[encounter_type][:bosses]
      troops = @encounters[encounter_type][:troops]

      # Choose a random boss
      boss = bosses.sample if !bosses.empty? && rand( 1 .. 2 ) == 1
      encounter.add_monster_while_possible(boss ) if boss

      # Choose a random monster
      monster = get_corresponding_monsters( troops, party_xp_level ).sample
      # We couldn't get a monster of this type for this party. Probably the monsters are too hard
      # Then we have to check again with another monster type
      unless monster
        tested_encounters_types << encounter_type
        next
      end

      # Will add the same monster while party_xp_level is not reached
      loop do
        break unless encounter.add_monster_while_possible(monster )
      end

      break
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

