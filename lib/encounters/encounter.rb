class Encounter

  attr_reader :xp_value

  def initialize( monster, amount )
    @monster = monster
    @amount = amount
    @xp_value = encounter_xp_value
  end

  def to_s
    "#{@amount} #{@monster.name}"
  end

  private

  def encounter_xp_value
    1.upto(@amount).map{ @monster.xp_value }.reduce(&:+) * get_encounter_multiplier
  end

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