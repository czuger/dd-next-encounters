require_relative '../data/by_xp_encounters'
require_relative 'encounter'

class Encounters

  include ByXpEncounters
  @@by_xp_encounters = nil

  def self.get_encounter( min_xp, max_xp )
    raise 'Encounters not loaded' unless @@by_xp_encounters
    encounters = @@by_xp_encounters.map{ |k_value, encounters| encounters if k_value <= max_xp && k_value >= min_xp }.compact.flatten
    encounters = encounters.compact.flatten
    encounters.sample
  end

  def self.load_by_xp_encounters( monster_manual )
    BY_XP_ENCOUNTERS.each do |k, v|
      @@by_xp_encounters[ k ] = v.map{ |e| Encounter.new( monster_manual.get( v[:monster_key] ), v[:amount] ) }
    end
  end

end