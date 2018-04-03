require_relative '../data/lairs_data'
require_relative 'encounters'

class Lairs
  include LairsData

  def initialize
    @encounters = Encounters.new
  end

end