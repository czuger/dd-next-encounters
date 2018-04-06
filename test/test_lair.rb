require 'test_helper'

class TestLair < Minitest::Test

  def setup
    @lairs = Lairs.new( :medium, [3]*4 )
  end

  def test_get_party_encounter
    assert_match /\d+ \w+/,  Lairs.new( :medium, [3]*4 ).encounter.to_s
  end

  def test_get_party_encounter_with_very_low_value
    assert_match /\d+ \w+/,  Lairs.new( :easy, [1]*4 ).encounter.to_s
  end

  def test_get_party_encounter_with_very_high_value
    assert_match /\d+ \w+/,  Lairs.new( :deadly, [20]*4 ).encounter.to_s
  end

  def test_a_weak_party
    assert_raises do
      Lairs.new( :deadly, [1]*2 ).encounter.to_s
    end
  end

  def test_too_low_levels
    assert_raises do
      Lairs.new( :deadly, [0]*4 ).encounter.to_s
    end
  end

  def test_too_high_levels
    assert_raises do
      Lairs.new( :deadly, [21]*4 ).encounter.to_s
    end
  end

  def test_get_party_encounter_the_brutal_way
    [ :easy, :medium, :hard, :deadly ].each do |difficulty|
      # Need to update this to 1..20 when bigger monster will be in the encounters.txt file
      (1..15).each do |party_level|
        # puts "Party level = #{party_level}"
        (3..8).each do |party_count|
          party = (1..party_count).map{ party_level }
          # puts "Party = #{party.inspect}"
          assert_match /\d+ \w+/,  Lairs.new( difficulty, party ).encounter.to_s
        end
      end
    end
  end

end
