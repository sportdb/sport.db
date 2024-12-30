###########################
#  to run use:
#    $ ruby sandbox/test_misc.rb


## note: use the local version of fifa gem
$LOAD_PATH.unshift( File.expand_path( '../sport.db/sportdb-structs/lib'))
$LOAD_PATH.unshift( File.expand_path( './lib'))
require 'fifa'



all = Fifa.world.countries
puts "   #{all.size} countries"
#=> 241 countries

fifa = Fifa.countries
puts "   #{fifa.size} countries"
fifa = Fifa.members('fifa')
puts "   #{fifa.size} countries"
#=> 211 countries

uefa =  Uefa.countries
puts "   #{uefa.size} countries"
uefa =  Fifa.members('uefa')
puts "   #{uefa.size} countries"
#=> 55 countries
pp uefa


pp Fifa[ 'aut' ]
pp Fifa[ 'AUT' ]
# pp FIFA[ 'aut' ]
# pp FIFA[ 'AUT' ]

pp Fifa.world.find( 'aut' )
pp Fifa.world.find( 'AUT' )

pp Fifa::VERSION
pp Fifa.banner
pp Fifa.data_dir
pp Fifa.root

pp Fifa.world.find_by_name( 'Austria' )
pp Fifa.world.find_by_name( 'austria' )
pp Fifa.world.find_by_name( 'a u s t r i a' )
pp Fifa.world.find_by_name( 'a.u.s.t.r.i.a' )
pp Fifa.world.find_by_name( 'Österreich' )

pp Fifa.world.find_by_name( 'Germany' )
pp Fifa.world.find_by_name( 'Deutschland' )

pp Fifa.world.find_by_name( 'Kosovo' )
pp Fifa.world.find_by_code( 'Kos' )
pp Fifa.world.find_by_code( 'kvx' )
pp Fifa.world.find_by_code( 'xk' )

pp Fifa.world.find_by_name( 'United States' )
pp Fifa.world.find_by_name( 'USA' )

pp Fifa.world.find_by_name( 'Yugoslavia' )
pp Fifa.world.find_by_name( 'East Germany' )


pp Fifa.world.find_by_code( 'iri' )
pp Fifa.world.find_by_code( 'saud' )
pp Fifa.world.find_by_code( 'nirl' )
pp Fifa.world.find_by_code( 'ö' )
pp Fifa.world.find_by_code( 'd' )
pp Fifa.world.find_by_code( 'i' )


puts "bye"
