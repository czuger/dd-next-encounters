require 'pp'
require 'yaml'

monsters_group_data = {}
default_group_entry = '{ groups: [], boss: false, superior_to: [] }'

File.open( 'data/groups.txt', 'r' ) do |f|
  f.readlines.each do |line|
    next if line[0] == '#'
    line = line.split
    next if line.empty?
    group = line.shift.to_sym
    line.each do |m|
      monsters_group_data[ m.to_sym ] ||= eval( default_group_entry )
      monsters_group_data[ m.to_sym ][ :groups ] << group
    end
  end
end

File.open( 'data/bosses.txt', 'r' ) do |f|
  f.readlines.each do |line|
    next if line[0] == '#'
    line = line.split
    next if line.empty?
    line.each do |m|
      monsters_group_data[ m.to_sym ] ||= eval( default_group_entry.clone )
      monsters_group_data[ m.to_sym ][ :boss ] = true
    end
  end
end

File.open( 'data/hierarchy.txt', 'r' ) do |f|
  f.readlines.each do |line|
    next if line[0] == '#'
    line = line.split()
    next if line.empty?
    superior, _, inferior = line
    monsters_group_data[ superior.to_sym ] ||= eval( default_group_entry.clone )
    monsters_group_data[ superior.to_sym ][ :superior_to ] << inferior.to_sym
  end
end

File.open( 'data/monsters_group_data.yml', 'w' ){ |f| f.write monsters_group_data.to_yaml }