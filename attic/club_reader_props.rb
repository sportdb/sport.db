
club_rec = m[0]
## todo/fix:  warn if name differes from (canonical) name
## todo/fix:  also add props to in-memory structs/records!!!
## todo/fix:   only updated "on-demand" from in-memory struct/records!!!!

## update database
club = Sync::Club.find_or_create( club_rec )
##  update attributes
attributes = {}
attributes[:key]  = rec[:key]      if rec[:key]
attributes[:code] = rec[:code]     if rec[:code]

club.attributes = attributes
club.save!
