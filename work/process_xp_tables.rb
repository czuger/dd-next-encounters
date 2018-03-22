require 'yaml'

xp_table = {}

difficulties = [ :easy, :medium, :hard, :deadly ]

File.open( 'data/xp_tables.txt', 'r' ) do |f|
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

File.open( '../db/xp_difficulty_table.yml', 'w' ){ |f| f.write xp_table.to_yaml }