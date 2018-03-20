require_relative 'lib/monsters_manual'

m = MonstersManual.new
m.read

p m.sources
p m.types
p m.challenges