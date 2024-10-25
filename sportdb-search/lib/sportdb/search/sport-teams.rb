
module Sports


class NationalTeam
    def self._search() CatalogDb::Metal::NationalTeam; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?


  ### todo/fix
  ###   upstream only support/require find !!!!!!!

  ## change core api to match( q ) only - why? why not?
  ##   and make find and find! derivs???
  def self.find( q )    _search.find( q ); end
  def self.find!( q )   _search.find!( q ); end
end # class NationalTeam


  class Team
    ## note: "virtual" index lets you search clubs and/or national_teams (don't care)

        ## todo/check: rename to/use map_by! for array version - why? why not?
        def self.find_by!( name:, league:, mods: nil )
          if name.is_a?( Array )
            recs = []
            name.each do |q|
              recs << _find_by!( name: q, league: league, mods: mods )
            end
            recs
          else  ## assume single name
            _find_by!( name: name, league: league, mods: mods )
          end
        end


      CLUB_NAME_RE =  %r{^
              (?<name>[^()]+?)     ## non-greedy
              (?:
                 \s+
                 \(
                   (?<code>[A-Z][A-Za-z]{2,3})    ## optional (country) code; support single code e.g. (A) - why? why not?
                 \)
              )?
            $}x   ## note - allow (URU) and (Uru) - why? why not


        ###
        #  note:  missing teams will get
        ##            auto-created if possible
        ##         only ambigious results (too many matches) raise expection!!!
        def self._find_by!( name:, league:, mods: nil )
          if mods && mods[ league.key ] && mods[ league.key ][ name ]
            mods[ league.key ][ name ]
          else
            if league.clubs?

             ## check for placeholder/global dummy clubs first
             if ['N.N.', 'N. N.'].include?( name )
                 Club.find!( name )
             else
               if league.intl?    ## todo/fix: add intl? to ActiveRecord league!!!
                     ###
                     ##  get country code from name
                     ##    e.g. Liverpool FC (ENG) or
                     ##         Liverpool FC (URU) etc.

                     ## check for country code
                     if m=CLUB_NAME_RE.match( name )
                       if m[:code]
                         rec =  Club.find_by( name: m[:name],
                                              country: m[:code] )
                         if rec.nil?
                           puts "auto-create (missing) club #{name}"
                           ##  todo/fix: add auto flag!!!!
                           ###              like in rounds!!!
                           ##   to track auto-created clubs
                           rec = Club.new( name: m[:name], auto: true )
                           rec.country = Country.find_by( code: m[:code] )   ## fix: country kwarg not yet supported!!
                           pp rec
                         end
                         rec
                       else
                          Club.find!( name )
                       end
                     else
                       puts "!! PARSE ERROR - invalid club name; cannot match with CLUB_NAME_RE >#{team}<"
                       exit 1
                     end
              else  ## assume clubs in domestic/national league tournament
                 ## note - search by league countries (may incl. more than one country
                 ##             e.g. us incl. ca, fr incl. mc, ch incl. li, etc.
                rec = Club.find_by( name: name, league: league )
                if rec.nil?
                    puts "auto-create (missing) club #{name}"
                    ##  todo/fix: add auto flag!!!!
                    ###              like in rounds!!!
                    ##   to track auto-created clubs
                    rec = Club.new( name: name, auto: true )
                    rec.country = league.country  ## fix: country kwarg not yet supported!!
                    pp rec
                end
                rec
                end
              end
            else   ## assume national teams (not clubs)
              NationalTeam.find!( name )
            end
          end
        end # method _find_by!
  end # class Team
end  # module Sports