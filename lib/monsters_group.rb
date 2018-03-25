class MonstersGroup

  def initialize
    @troops = []
    @bosses = []
  end

  def add_monster( monster )
    @troops << monster unless monster.boss
    @bosses << monster if monster.boss
  end

  def to_s
    { troops: @troops.map{ |m| m.key }, bosses: @bosses.map{ |m| m.key } }
  end

end