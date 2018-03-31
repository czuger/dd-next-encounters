require_relative 'encounter'
require_relative '../data/xp_difficulty_table'

class Lair

  include XpDifficultyTable

  AVAILABLE_ENCOUNTER_LEVEL = REVERSED_XP_DIFFICULTY_TABLE.keys

  def initialize( *encounters_types )
    @monster_manual = MonstersManual.new
    @monsters = nil
  end

  def read_manuals
    read_monster_manual
  end

  def print_summary
    p @monster_manual.sources
    puts
    p @monster_manual.types
    puts
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

    party_xp_level = hero_level.map{ |hl| XP_DIFFICULTY_TABLE[hl][encounter_level] }.reduce(&:+)
    one_sixth_party_xp_level = party_xp_level / 6

    candidate_monsters = @monster_manual.select( sources: [ 'Basic Rules', 'Monster Manual' ], types: %w( Undead Fiend Giant Humanoid ) )
    candidate_monsters = candidate_monsters.reject{ |m| m.xp_value > party_xp_level || m.xp_value < one_sixth_party_xp_level }

    choosed_monster = candidate_monsters.sample
    monsters_amount = ( party_xp_level / choosed_monster.xp_value ).floor

    encounter = Encounter.new( party_xp_level )
    1.upto(monsters_amount).each do
      # p encounter
      break unless encounter.add_monster_while_possible( choosed_monster )
    end

    encounter
  end

  private

  def read_monster_manual
    @monster_manual.load
    # validate_encounters_types

    @monsters = @monster_manual.select( sources: [ 'Basic Rules', 'Monster Manual' ] )

    # @encounters_types.each do |encounter_type|
    #   @encounters[encounter_type] ||= { troops: [], bosses: [] }
    #   @encounters[encounter_type][:troops] = @monster_manual.groups[encounter_type]&.troops
    #   @encounters[encounter_type][:bosses] = @monster_manual.groups[encounter_type]&.bosses
    # end
  end

  private

  # def validate_encounters_types
  #   @encounters_types.each do |encounter_type|
  #     unless @monster_manual.groups.include?( encounter_type )
  #       raise "Bad lair type : #{encounter_type.inspect}" + ". Available lairs types : #{@monster_manual.groups.keys}"
  #     end
  #   end
  #   @encounters_types =  @monster_manual.groups.keys if @encounters_types.empty?
  # end

end

