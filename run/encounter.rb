require_relative '../lib/monsters_manual'
require_relative '../lib/lair'
require 'pp'

l = Lair.new( :goblin )
l.read_manuals

encounter =  l.get_encounter( :medium, 3, 3, 3, 3 )
puts encounter.to_s