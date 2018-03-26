class Encounter

  def initialize( party_xp_level )
    @monsters = []
    @party_xp_level = party_xp_level
  end

  # Return true or false. Monster added or not
  def add_monster_if_possible( monster )
    if can_add_monster?( monster )
      @monsters << monster
      return true
    end
    false
  end

  def can_add_monster?( monster )
    encounter_value( @monsters + [ monster ] ) <= @party_xp_level
  end

  def to_s
    @monsters.group_by {|i| i.key}.map{ |_, v| "#{v.count} #{v.first.name}"}.join( ', ' )
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

end