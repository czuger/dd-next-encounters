require 'yaml'
require 'pp'
require_relative '../lib/encounters/encounter'
require_relative '../lib/monsters/monsters_manual'

mm = MonstersManual.new
mm.load

by_xp_encounters = {}
encounters = []

File.open( 'data/encounters.txt', 'r' ) do |f|
  f.readlines.each_with_index do |line, index|
    next if index == 0 || line.chomp.size == 0
    l_data = line.split

    # p l_data

    amount = l_data.shift
    monster = l_data.shift

    amount_data = amount.match /(\d+)-(\d+)/
    min_monsters = amount_data[1].to_i
    max_monsters = amount_data[2].to_i

    min_monsters.upto( max_monsters ).each do |monster_amount|

      e = Encounter.new( mm.get( monster.to_sym ), monster_amount )

      encounters << e.to_hash

      by_xp_encounters[ e.xp_value ] ||= []
      by_xp_encounters[ e.xp_value ] << e.id

    end

  end
end

File.open( '../lib/data/encounters_data.rb', 'w' ) do |f|
  f.puts 'module EncountersData'
  f.puts "\t ENCOUNTERS = "
  PP.pp(encounters,f )
  f.puts
  f.puts "\t BY_XP_ENCOUNTERS = "
  PP.pp(by_xp_encounters,f )
  f.puts 'end'

end