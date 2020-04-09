##
#  from CsvMatchReader
#
#
#   no longer support "built-in" normalize team names!!!


##
##  todo/check: what keyword to use for normalize names - normalize? canonicalize? other?
##    note: todo/fix: allow passing in of country filter for normalize too - why? why not?

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    ##  use "global" default/built-in team mappings for now
    ##   todo/fix:  make more flexible
    if normalize
        club_mappings = SportDb::Import.config.clubs
        ## fix/todo: if country defined - use filter
        m = club_mappings.match( team1 )
        if m.nil? || m.size > 1
          puts "** !!! ERROR !!! - no match or too many matches found for >#{team1}<"
          pp m
          exit 1
        else
          team1 = m[0].name
        end
 
        m = club_mappings.match( team2 )
        if m.nil? || m.size > 1
          puts "** !!! ERROR !!! - no match or too many matches found for >#{team1}<"
          pp m
          exit 1
        else
          team2 = m[0].name
        end
     end
 
 