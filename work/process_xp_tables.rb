require 'pp'

xp_table = {}

difficulties = [ :easy, :medium, :hard, :deadly ]

File.open( 'data/xp_difficulty_table.txt', 'r' ) do |f|
  f.readlines.each_with_index do |line, index|
    next if index == 0
    l_data = line.split.map{ |e| e.to_i }
    level = l_data.shift
    xp_table[ level ] ||= {}
    0.upto(3) do |diff|
      xp_table[ level ][ difficulties[ diff ] ] = l_data.shift
    end

  end
end

File.open( '../lib/data/xp_difficulty_table.rb', 'w' ) do |f|
  f.puts 'module XpDifficultyTable'
  f.puts "\t XP_DIFFICULTY_TABLE = "
  PP.pp(xp_table,f )
  f.puts 'end'
end