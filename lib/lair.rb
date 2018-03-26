require_relative 'encounter'

class Lair

  AVAILABLE_ENCOUNTER_LEVEL=[ :easy, :medium, :hard, :deadly ]
  def initialize( lair_type )
    @monster_manual = MonstersManual.new
    @monsters = nil
    @xp_difficulty_table = {}
    @lair_type = lair_type
  end

  def read_manuals
    read_monster_manual
    read_xp_difficulty_table
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

    # Choose a random boss
    boss = @bosses.sample if @bosses && rand( 1 .. 4 ) == 4
    encounter.add_monster_if_possible( boss ) if boss

    # Choose a random monster
    monster = get_corresponding_monsters( party_xp_level ).sample

    loop do
      break unless encounter.add_monster_if_possible( monster )
    end

    encounter
  end

  private

  def get_corresponding_monsters( party_xp_level)
    @troops.map{ |m| m if m.xp_value < party_xp_level }.compact
  end

  def read_monster_manual
    @monster_manual.load
    validate_lair_type

    @monsters = @monster_manual.select( sources: [ 'Basic Rules', 'Monster Manual' ] )

    @troops = @monster_manual.groups[@lair_type]&.troops
    @bosses = @monster_manual.groups[@lair_type]&.bosses
    @bosses = nil if @bosses.empty?
    # @monsters.reject!{ |m| !CONTENT[@lair_type].include?( m.key ) }
  end

  def read_xp_difficulty_table
    @xp_difficulty_table = YAML.load_file('db/xp_difficulty_table.yml' )
  end

  private

  def validate_lair_type
    unless @monster_manual.groups.include?( @lair_type )
      raise "Bad lair type : #{@lair_type.inspect}" + ". Available lairs types : #{@monster_manual.groups.keys}"
    end
  end

end
