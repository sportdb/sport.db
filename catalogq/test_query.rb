require_relative 'query'



Country = CatalogDb::Metal::Country
Club    = CatalogDb::Metal::Club


pp Country.count
pp Club.count

pp Club.match_by_name( 'arsenal' )
pp Club.match_by_name( 'xxx' )
pp Club.match_by_name( 'liverpool' )

pp Club.match_by_name( 'az' )
pp Club.match_by_name( 'bayern' )


pp Country.find_by_name( 'austria' )
pp Country.find_by_name( 'deutschland' )
pp Country.find_by_name( 'iran' )

pp Country[ 'austria' ]
pp Country[ 'at' ]


puts "bye"
