require_relative 'lib/monsters_manual'

m = MonstersManual.new
m.read

p m.sources
p m.types
p m.challenges

m.select( sources: [ 'Basic Rules', 'Monster Manual' ], types: [ 'Undead' ], min_challenge: 1.0/2, max_challenge: 2 ).each do |m|
  p m
end