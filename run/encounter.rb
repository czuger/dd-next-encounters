require_relative '../lib/encounters/encounters'
require_relative '../lib/encounters/lairs'
require 'pp'

# e = Encounters.new
#
# encounter =  e.get_party_encounter( :medium, 3, 3, 3, 3 )
# puts encounter.to_s

l = Lairs.new :medium, [5]*4

1.upto(5).each do
  p l.encounter.to_s
end
