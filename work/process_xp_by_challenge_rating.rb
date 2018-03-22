require 'yaml'

xp_by_challenge_rating = {}

File.open( 'data/xp_by_challenge_rating.txt', 'r' ) do |f|
  f.readlines.each_with_index do |line, index|
    next if index == 0
    l_data = line.split

    1.upto 2 do
      level = l_data.shift
      level = level =~ /\d+\.\d+/ ? level.to_f : level.to_i
      value = l_data.shift.to_i
      xp_by_challenge_rating[ level ] = value
    end

  end
end

File.open( 'data/xp_by_challenge_rating.yml', 'w' ){ |f| f.write xp_by_challenge_rating.to_yaml }