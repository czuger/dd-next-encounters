require_relative 'lib/monsters_manual'

m = MonstersManual.new
m.read

p m.sources
p m.types
p m.challenges

p m.select( sources: [ 'Basic Rules', 'Monster Manual' ], types: [ 'Undead' ] ).map{ |m| m.key }

# m.select( sources: [ 'Basic Rules', 'Monster Manual' ], types: [ 'Undead' ], min_challenge: 1.0/8, max_challenge: 30 ).each do |m|
#   p m
# end