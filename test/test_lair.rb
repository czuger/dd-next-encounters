require 'test_helper'

class TestLair < Minitest::Test

  def setup
    @encounters = Encounters.new()
  end

  def test_get_party_encounter
    assert_match /\d+ \w+/,  @encounters.get_party_encounter( :medium, 3, 3, 3, 3 ).to_s
  end

  def test_get_party_encounter_with_very_low_value
    assert_match /\d+ \w+/,  @encounters.get_party_encounter( :easy, 1, 1, 1, 1 ).to_s
  end

  def test_get_party_encounter_with_very_high_value
    assert_match /\d+ \w+/,  @encounters.get_party_encounter( :deadly, 20, 20, 20, 20 ).to_s
  end

  def test_an_empty_party
    assert_raises do
      @encounters.get_party_encounter( :deadly ).to_s
    end
  end

  def test_a_weak_party
    assert_raises do
      @encounters.get_party_encounter( :deadly, [ 1, 1 ] ).to_s
    end
  end

  def test_too_low_levels
    assert_raises do
      @encounters.get_party_encounter( :deadly, [ 0, 0, 0, 0 ] ).to_s
    end
  end

  def test_too_high_levels
    assert_raises do
      @encounters.get_party_encounter( :deadly, [ 21, 21, 21, 21 ] ).to_s
    end
  end

  def test_get_party_encounter_the_brutal_way
    [ :easy, :medium, :hard, :deadly ].each do |difficulty|
      # Need to update this to 1..20 when bigger monster will be in the encounters.txt file
      (1..9).each do |party_level|
        # puts "Party level = #{party_level}"
        (3..8).each do |party_count|
          party = (1..party_count).map{ party_level }
          # puts "Party = #{party.inspect}"
          assert_match /\d+ \w+/,  @encounters.get_party_encounter( difficulty, *party ).to_s
        end
      end
    end
  end

end
