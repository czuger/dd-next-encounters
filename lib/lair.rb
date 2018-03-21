class Lair

  CONTENT = {
      undead_basic: [ :zombie, :skeleton, :ghoul ],
      undead_mythical: [ :zombie, :skeleton, :ghoul, :minotaur_skeleton, :mummy, :mummy_lord ],
      undead_vampire: [ :zombie, :skeleton, :ghoul, :vampire, :vampire_spawn, :vampire_spellcaster, :vampire_warrior ],
      gobelin_basic: [ :goblin, :goblin_boss, :hobgoblin, :hobgoblin_captain, :hobgoblin_warlord, :bugbear, :bugbear_chief ],
      orc_basic: [ :orc_war_chief, :orc ]
  }

  def initialize( lair_type )
    @monster_manual = MonstersManual.new
    @monsters = nil
    @xp_table = {}
    @lair_type = lair_type
  end

  def read_manuals
    read_monster_manual
    read_xp_table
  end

  # Encounter level : 0 -> 3
  # 0 : Easy
  # 3 : Deadly
  def get_encounter( encounter_level, *hero_level )
    raise "Bad encounter level : #{encounter_level.inspect}" if encounter_level < 0 || encounter_level > 3
    heros_level = hero_level.map{ |hl| @xp_table[hl][encounter_level] }.reduce(&:+)

  end

  private

  def read_monster_manual
    @monster_manual.read

    @monsters = @monster_manual.select( sources: [ 'Basic Rules', 'Monster Manual' ] )
    @monsters.reject!{ |m| !CONTENT[@lair_type].include?( m.key ) }
  end

  def read_xp_table
    @xp_table = YAML.load_file( 'db/xp_table.yml' )
  end

end
