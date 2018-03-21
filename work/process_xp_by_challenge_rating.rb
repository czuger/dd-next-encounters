require 'yaml'
require_relative '../lib/monsters_manual'

xp_by_challenge_rating = {}

File.open( 'work/xp_by_challenge_rating.txt', 'r' ) do |f|
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

m = MonstersManual.new
m.load
m.set_xp( xp_by_challenge_rating )

m.save