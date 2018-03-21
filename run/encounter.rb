require_relative '../lib/monsters_manual'
require_relative '../lib/lair'
require 'pp'

l = Lair.new( :bugbear_basic )
l.read_manuals

encounter =  l.get_encounter( 1, 3, 3, 3, 3 )
puts encounter.to_s

pp Lair::CONTENT[:bugbear_basic].to_yaml

p YAML.load_file( 'db/encounters/gobelins.yml' )