require_relative '../lib/monsters/monsters_manual'
require_relative '../lib/encounters/lair'
require 'pp'

l = Lair.new( :goblin, :hobgoblin, :undead, :bugbear, :orc )
l.read_manuals

l.print_summary

encounter =  l.get_encounter( :medium, 3, 3, 3, 3 )
puts encounter.to_s