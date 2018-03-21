require_relative 'lib/ib/monsters_manual'
require_relative 'lib/lair'

l = Lair.new( :gobelin_basic )
l.read_manuals

encounter =  l.get_encounter( 1, 3, 3, 3, 3 )
puts encounter.to_s

m = MonstersManual.new
m.read
#
# p m.sources
# p m.types
# p m.challenges
#
# p m.select( sources: [ 'Basic Rules', 'Monster Manual' ], types: [ 'Undead' ] ).map{ |m| m.key }
#
# puts
# m.select( sources: [ 'Basic Rules', 'Monster Manual' ], types: [ 'Undead' ], min_challenge: 1.0/8, max_challenge: 2 ).each do |m|
#   p m
# end