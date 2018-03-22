require 'pp'
require 'yaml'

monsters_group_data = {}

File.open( 'data/groups.txt', 'r' ) do |f|
  f.readlines.each do |line|
    next if line[0] == '#'
    line = line.split
    next if line.empty?
    p line
    group = line.shift.to_sym
    line.each do |m|
      monsters_group_data[ m.to_sym ] ||= { groups: [] }
      monsters_group_data[ m.to_sym ][ :groups ] << group
    end
  end
end

File.open( 'data/monsters_group_data.yml', 'w' ){ |f| f.write monsters_group_data.to_yaml }