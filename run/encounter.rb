require_relative '../lib/monsters_manual'
require_relative '../lib/lair'
require 'pp'

l = Lair.new( :goblins )
l.read_manuals

p l.groups
encounter =  l.get_encounter( 1, 3, 3, 3, 3 )
puts encounter.to_s