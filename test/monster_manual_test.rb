require 'test_helper'

class MonsterManualTest < Minitest::Test

  def setup
    @mm = MonstersManual.new
    @mm.load
  end

  def test_select
    assert_instance_of Monster,@mm.select( sources: [ 'Basic Rules', 'Monster Manual' ] ).first
  end

  def test_add_monster
    m = Monster.new( 1, 'test', :test, :test )
    m.add_groups( [ :test ] )
    @mm.add_monster( m )
    assert_equal :test, @mm.monsters[:test].type
    @mm.save( 'mm_test.dummy' )
    assert File.exist?( 'mm_test.dummy' )
    `rm mm_test.dummy`
  end

end
