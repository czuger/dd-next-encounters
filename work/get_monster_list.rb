require 'nokogiri'
require 'open-uri'
require 'pp'
require 'yaml'

require_relative '../lib/monster'

base_page = 'https://www.dndbeyond.com/'
next_page = 'monsters'

def read_page( page, monsters )
  page.css( '//div[data-type=monsters]' ).each do |monster|
    challenge = monster.css( 'div.monster-challenge' ).children.children.text.to_i
    name = monster.css( 'div.monster-name' ).children.children.children.text
    source = monster.css( 'div.monster-name' ).children.children.last.text

    type = monster.css( 'div.monster-type' ).children.children.text

    # p monster.css( 'div.monster-environment' ).children.children.text

    monsters << Monster.new( challenge, name, source, type )
  end
  monsters
end

monsters = []
while next_page
  puts 'reading ' + next_page
  bp = Nokogiri::HTML( open( base_page + next_page ).read )
  monsters = read_page( bp, monsters )

  next_page = bp.css( '//a[data-next-page]' ).first
  next_page = next_page.attributes['href'].value if next_page
  # break
end

# pp monsters

File.open('../db/monsters.yml', 'w') {|f| f.write monsters.to_yaml }

