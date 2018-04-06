require 'test_helper'

class TestEncounters < Minitest::Test

  def setup
    @encounters = Encounters.new()
  end

  def test_basic_encounter
    @mm = MonstersManual.new
    @mm.load
    assert_equal '3 Orc', Encounter.new( @mm.get( :orc ), 3 ).to_s
  end

end
