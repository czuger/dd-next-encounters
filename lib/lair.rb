class Lair

  CONTENT = {
      undead_basic: [ :zombie, :skeleton, :ghoul, :shadow, :specter, :ghast ],
      undead_mythical: [ :zombie, :skeleton, :ghoul, :minotaur_skeleton, :mummy, :mummy_lord ],
      undead_vampire: [ :zombie, :skeleton, :ghoul, :vampire, :vampire_spawn, :vampire_spellcaster, :vampire_warrior ],
      gobelin_basic: [ :goblin, :goblin_boss, :hobgoblin, :hobgoblin_captain, :hobgoblin_warlord, :bugbear, :bugbear_chief ],
      orc_basic: [ :orc_war_chief, :orc ]
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
  def get_encounter( encounter_level, *hero_level, encounter_base = [] )
    raise "Bad encounter level : #{encounter_level.inspect}" if encounter_level < 0 || encounter_level > 3
    party_xp_level = hero_level.map{ |hl| @xp_table[hl][encounter_level] }.reduce(&:+)

    # Choose a random monster
    monster = get_corresponding_monsters( party_xp_level ).sample
    encounter = encounter_base

    loop do
      break if encounter_value( encounter + [ monster ] ) > party_xp_level
      encounter << monster
    end

    encounter
  end

  private

  def encounter_value( encounter )
    encounter.map{ |e| e.xp_value }.reduce(&:+) * get_encounter_multiplier( encounter )
  end

  def get_encounter_multiplier( encounter )
    count = encounter.count
    mul = 1
    mul = 1.5 if count >= 2
    mul = 2 if count >= 3
    mul = 2.5 if count >= 7
    mul = 3 if count >= 11
    mul = 4 if count >= 15
    mul
  end

  def get_corresponding_monsters( party_xp_level)
    @monsters.map{ |m| m if m.xp_value < party_xp_level }.compact
  end

  def read_monster_manual
    @monster_manual.read

    @monsters = @monster_manual.select( sources: [ 'Basic Rules', 'Monster Manual' ] )
    @monsters.reject!{ |m| !CONTENT[@lair_type].include?( m.key ) }
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
