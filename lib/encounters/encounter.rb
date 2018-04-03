class Encounter

  attr_reader :xp_value, :id

  def initialize( monster, amount, id = nil, xp_value = nil )
    @monster = monster
    @amount = amount
    @xp_value = xp_value ? xp_value : encounter_xp_value.to_i
    @id = id ? id : ( monster.key.to_s + '_' + amount.to_s ).to_sym
  end

  def to_s
    "#{@amount} #{@monster.name}"
  end

  def to_hash
    { id: @id, monster_key: @monster.key, amount: @amount, xp_value: @xp_value }
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