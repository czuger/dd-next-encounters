require_relative '../lib/encounters/encounters'
require_relative '../lib/encounters/lairs'
require 'pp'

# e = Encounters.new
#
# encounter =  e.get_party_encounter( :medium, 3, 3, 3, 3 )
# puts encounter.to_s

l = Lairs.new
p l.get_party_encounter( :easy, [1]*4 )