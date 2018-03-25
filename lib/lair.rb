require_relative 'encounter'

class Lair

  CONTENT = {
      undead_basic: { bosses: [], troops: [ :zombie, :skeleton, :ghoul, :shadow, :specter, :ghast ] },
      undead_mythical: { bosses: [], troops: [ :zombie, :skeleton, :ghoul, :minotaur_skeleton, :mummy, :mummy_lord ] },
      undead_vampire: { bosses: [], troops: [ :zombie, :skeleton, :ghoul, :vampire, :vampire_spawn, :vampire_spellcaster, :vampire_warrior ] },
      gobelin_basic: { bosses: [ :goblin_boss ], troops:[ :goblin ] },
      hobgobelin_basic: { bosses: [ :hobgoblin_captain, :hobgoblin_warlord ], troops:[ :hobgoblin ] },
      bugbear_basic: { bosses: [ :bugbear_chief ], troops:[ :bugbear ] },
      orc_basic: { bosses: [ :orc_war_chief, :orc_eye_of_gruumsh ], troops:[ :orc ] }
  }

  def initialize( lair_type )
    @monster_manual = MonstersManual.new
    @monsters = nil
    @xp_table = {}
    @xp_by_challenge_rating = {}
    @lair_type = lair_type
  end

  def read_manuals
    read_monster_manual
    read_xp_table
    read_xp_by_challenge_rating_table
  end

  # Encounter level : 0 -> 3
  # 0 : Easy
  # 3 : Deadly
  def get_encounter( encounter_level, *hero_level )

    # TODO : rework this
    # - Create an encounter from troops only
    # - If troops count >= 6
    #   - try to find an available boss.
    #   - If can form a group with boss and at least 2 sbires, take it
    #   - Otherwise keep troops.

    # + Integrate group in monster manual
    # Work from list
    # Add a boss tag to the monster (work from a key list)

    # Need to integrate hierarchy. Bugbear can't be lead by gobelin boss

    raise "Bad encounter level : #{encounter_level.inspect}" if encounter_level < 0 || encounter_level > 3
    party_xp_level = hero_level.map{ |hl| @xp_table[hl][encounter_level] }.reduce(&:+)

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
    @monster_manual.read

    @monsters = @monster_manual.select( sources: [ 'Basic Rules', 'Monster Manual' ] )
    @troops = @monsters.select{ |m| CONTENT[@lair_type][:troops].include?( m.key ) }
    @bosses = @monsters.select{ |m| CONTENT[@lair_type][:bosses].include?( m.key ) }
    @bosses = nil if @bosses.empty?
    # @monsters.reject!{ |m| !CONTENT[@lair_type].include?( m.key ) }
  end

  def read_xp_table
    @xp_table = YAML.load_file( 'db/xp_table.yml' )
  end

  def read_xp_by_challenge_rating_table
    @xp_by_challenge_rating = YAML.load_file('db/xp_by_challenge_rating.yml' )
    @monsters.each do |monster|
      monster.xp_value = @xp_by_challenge_rating[monster.challenge]
    end
  end

end
