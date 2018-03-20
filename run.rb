require_relative 'lib/monsters_manual'

m = MonstersManual.new
m.read

p m.sources
p m.types
p m.challenges

p m.select( sources: [ 'Basic Rules', 'Monster Manual' ], types: [ 'Undead' ] )