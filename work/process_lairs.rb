require 'yaml'
require 'pp'
require_relative '../lib/encounters/encounter'
require_relative '../lib/monsters/monsters_manual'

lairs = {}

File.open( 'data/lairs.txt', 'r' ) do |f|
  f.readlines.each_with_index do |line, index|
    next if line[0] == '#' || line.chomp.size == 0
    l_data = line.split

    lair_name = l_data.shift
    monsters = l_data

    lairs[ lair_name.to_sym ] = monsters.map{ |e| e.to_sym }

  end
end

# pp by_xp_encounters

File.open( '../lib/data/lairs_data.rb', 'w' ) do |f|
  f.puts 'module LairsData'
  f.puts "\t LAIRS_DATA = "
  PP.pp(lairs,f )
  f.puts 'end'
end