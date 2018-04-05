input = <<EOD
    Air Elemental	5	Élémentaire	G	neutre
Azer	2	Élémentaire	M	loyal neutre
Dust Mephit	1/2	Élémentaire	P	neutre mauvais
Earth Elemental	5	Élémentaire	G	neutre
Fire Elemental	5	Élémentaire	G	neutre
Fire Snake	1	Élémentaire	M	neutre mauvais
Galeb Duhr	6	Élémentaire	M	neutre
Gargoyle	2	Élémentaire	M	chaotique mauvais
Ice Mephit	1/2	Élémentaire	P	neutre mauvais
Invisible Stalker	6	Élémentaire	M	neutre
Magma Mephit	1/2	Élémentaire	P	neutre mauvais
Magmin	1/2	Élémentaire	P	chaotique neutre
Mud Mephit	1/4	Élémentaire	P	neutre mauvais
Salamander	5	Élémentaire	G	neutre mauvais
Smoke Mephit	1/4	Élémentaire	P	neutre mauvais
Steam Mephit	1/4	Élémentaire	P	neutre mauvais
Water Elemental	5	Élémentaire	G	neutre
Water Weird	3	Élémentaire	G	neutre
Xorn
EOD

monsters = []
input.split( "\n" ).each do |line|
  monsters << line.split( "\t" ).first.strip.downcase.gsub( ' ', '_' ).to_sym
end

monsters.each do |m|
  puts '1-6 ' + m.to_s
end

puts 'elementals ' + monsters.join( ' ' )


