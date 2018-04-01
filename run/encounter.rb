require_relative '../lib/monsters/monsters_manual'
require_relative '../lib/encounters/encounters'
require 'pp'

m = MonstersManual.new
m.load

Encounters.load_by_xp_encounters( m )

encounter =  Encounters.get_party_encounter( :medium, 3, 3, 3, 3 )
puts encounter.to_s