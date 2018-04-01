class Encounter

  def initialize( monster, amount )
    @monster = monster
    @amount = amount
    # @party_xp_level = party_xp_level
  end

  # Return true or false. Monster added or not
  def add_monster_while_possible(monster )
    raise "monster can't be nil : #{monster.inspect}" unless monster
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
    "#{@amount}. #{@monster.name}"
  end

  def encounter_xp_value
    1.upto(@amount).map{ @monster.xp_value }.reduce(&:+) * get_encounter_multiplier
  end

  private

  def get_encounter_multiplier
    count = @amount
    mul = 1
    mul = 1.5 if count >= 2
    mul = 2 if count >= 3
    mul = 2.5 if count >= 7
    mul = 3 if count >= 11
    mul = 4 if count >= 15
    mul
  end

end