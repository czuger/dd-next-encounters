require_relative '../lib/monsters_manual'
require_relative '../lib/lair'

m = MonstersManual.new
m.read

p m.sources
p m.types
p m.challenges

p m.select( sources: [ 'Basic Rules', 'Monster Manual' ], types: [ 'Undead' ] ).map{ |m| m.key }

p  m.select( sources: [ 'Basic Rules', 'Monster Manual' ] ).map{ |m| m.key.to_s }.select{ |n| n=~ /.*kob.*/ }

# puts
# m.select( sources: [ 'Basic Rules', 'Monster Manual' ], types: [ 'Undead' ], min_challenge: 1.0/8, max_challenge: 2 ).each do |m|
#   p m
# end