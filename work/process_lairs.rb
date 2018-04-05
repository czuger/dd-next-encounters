require 'yaml'
require 'pp'
require_relative '../lib/encounters/encounters'
require_relative '../lib/monsters/monsters_manual'

`ruby process_encounters.rb`

lairs = { lairs: {}, by_xp_lair: nil }
encounters = Encounters.new

File.open( 'data/lairs.txt', 'r' ) do |f|

  by_xp_lair = {}

  f.readlines.each_with_index do |line, index|
    next if line[0] == '#' || line.chomp.size == 0
    l_data = line.split

    lair_name = l_data.shift.to_sym
    monsters = l_data

    monsters = monsters.map{ |e| e.to_sym }
    # encounters_values = []
    by_encounters_xp = {}
    monsters.each do |monster_key|
      p monster_key
      encounters.by_monster(monster_key).each do |encounter|
        # encounters_values << encounter.xp_value
        by_encounters_xp[ encounter.xp_value ] ||= []
        by_encounters_xp[ encounter.xp_value ] << encounter.id

        by_xp_lair[ encounter.xp_value ] ||= []
        by_xp_lair[ encounter.xp_value ] << lair_name unless by_xp_lair[ encounter.xp_value ].include?( lair_name )
      end
    end

    lairs[ :lairs ][ lair_name ] = { monsters: monsters, by_encounters_xp: by_encounters_xp }
  end

  lairs[ :by_xp_lair ] = by_xp_lair
end

# pp by_xp_encounters

File.open( '../lib/data/lairs_data.rb', 'w' ) do |f|
  f.puts 'module LairsData'
  f.puts "\t LAIRS_DATA = "
  PP.pp(lairs,f )
  f.puts 'end'
end