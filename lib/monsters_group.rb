class MonstersGroup

  attr_reader :troops, :bosses

  def initialize
    @troops = []
    @bosses = []
    # This mean that this group is inferior to the listed groups. They wont accept
    @groups_inferiority = []
  end

  def add_monster( monster )
    @troops << monster unless monster.boss
    @bosses << monster if monster.boss
  end

  # def to_s
  #   { troops: @troops.map{ |m| m.key }, bosses: @bosses.map{ |m| m.key } }
  # end

end