require_relative '../lib/monsters_manual'

m = MonstersManual.new
m.load

File.open( 'work/groups.txt', 'w' ) do |f|
  m.monsters.keys.sort.each do |k|
    f.puts( k )
  end
end