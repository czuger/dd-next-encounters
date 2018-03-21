require 'yaml'

xp_table = {}

File.open( 'xp_tables.txt', 'r' ) do |f|
  f.readlines.each_with_index do |line, index|
    next if index == 0
    l_data = line.split.map{ |e| e.to_i }
    level = l_data.shift
    xp_table[ level ] = l_data
  end
end

File.open( '../db/xp_table.yml', 'w' ){ |f| f.write xp_table.to_yaml }