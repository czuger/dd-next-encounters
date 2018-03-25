require 'pp'
require 'yaml'

monsters_group_data = {}
groups_monsters_data = {}

default_group_entry = '{ groups: [], boss: false, superior_to: [] }'

File.open( 'data/groups.txt', 'r' ) do |f|
  f.readlines.each do |line|
    next if line[0] == '#'
    line = line.split
    next if line.empty?
    group = line.shift.to_sym
    line.each do |m|

      groups_monsters_data[ group ] ||= []
      if m =~ /\[.+\]/
        sub_group = m.match( /\[(.+)\]/ )
        sub_group = sub_group[1].to_sym
        monsters_group_data[ group ] ||= eval( default_group_entry )
        monsters_group_data[ group ][ :groups ] += groups_monsters_data[ sub_group ]
        groups_monsters_data[ group ] += groups_monsters_data[ sub_group ]
      else
        monsters_group_data[ m.to_sym ] ||= eval( default_group_entry )
        monsters_group_data[ m.to_sym ][ :groups ] << group
        groups_monsters_data[ group ] << m.to_sym
      end
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

# For future use
bosses_in_groups = groups_monsters_data.map{ |k, v| [ k, v.select{ |monster| monsters_group_data[monster][:boss] if monsters_group_data[monster] } ] }

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