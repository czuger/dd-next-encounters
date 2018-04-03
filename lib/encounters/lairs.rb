require_relative '../data/lairs_data'
require_relative 'encounters'

class Lairs
  include LairsData

  def initialize
    @encounters = Encounters.new

    @lairs_by_xp_range = []
    LAIRS_DATA.each do |k, v|
      @lairs_by_xp_range
    end
  end

end