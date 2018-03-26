require 'test_helper'

class LairTest < Minitest::Test

  def setup
    @lair = Lair.new( :goblin )
    @lair.read_manuals
  end

  def test_select
    assert_match /Goblin/,  @lair.get_encounter( :medium, 3, 3, 3, 3 ).to_s
  end

end
