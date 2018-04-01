require_relative '../lib/encounters/encounters'
require 'pp'

e = Encounters.new

encounter =  e.get_party_encounter( :medium, 3, 3, 3, 3 )
puts encounter.to_s