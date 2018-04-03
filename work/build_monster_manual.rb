require 'yaml'
require_relative '../lib/monsters/monsters_manual'

mm = MonstersManual.new

monsters = YAML::load_file('data/monsters.yml')
xp_by_challenge_rating_table = YAML::load_file('data/xp_by_challenge_rating.yml')

bosses = []
File.open( 'data/bosses.txt', 'r' ) do |f|
  f.readlines.each do |line|
    next if line[0] == '#'
    line = line.split.map{ |e| e.to_sym }
    next if line.empty?
    bosses += line
  end
end

monsters.each do |monster|
  monster.xp_value = xp_by_challenge_rating_table[monster.challenge]
  monster.boss = true if bosses.include?(monster.key)
  mm.add_monster( monster )
end

mm.save( '../lib/data/monsters_manual_content.rb' )