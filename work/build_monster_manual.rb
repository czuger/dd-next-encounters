require 'yaml'
require_relative '../lib/monsters/monsters_manual'

mm = MonstersManual.new

monsters = YAML::load_file('data/monsters.yml')
xp_by_challenge_rating_table = YAML::load_file('data/xp_by_challenge_rating.yml')
groups = YAML::load_file('data/monsters_group_data.yml')

monsters.each do |monster|
  monster.xp_value = xp_by_challenge_rating_table[monster.challenge]
  monster.boss = groups[monster.key] ? groups[monster.key][:boss] : false
  monster.add_groups( groups[monster.key] ? groups[monster.key][:groups] : [] )
  mm.add_monster( monster )
end

mm.save( '../db/monsters_manual.yml' )