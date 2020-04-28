
module SportDb
  class Package

    ## note: add readers here; for full class def see the sourcein sportdb-formats!!!

    def read_leagues
      each_leagues { |entry| SportDb.parse_leagues( entry.read ) }
    end

    def read_clubs
      each_clubs { |entry| SportDb.parse_clubs( entry.read ) }
    end

    def read_club_props
      each_club_props { |entry| SportDb.parse_club_props( entry.read ) }
    end


    def read_conf( *names, season: nil )
      if names.empty?   ## no (entry) names passed in; read in all
        each_conf do |entry|
          SportDb.parse_conf( entry.read, season: season )
        end
      else
        names.each do |name|
          entry = @pack.find( name )
          SportDb.parse_conf( entry.read, season: season )
        end
      end
    end

    def read_match( *names, season: nil )
      if names.empty?   ## no (entry) names passed in; read in all
        each_match do |entry|
          SportDb.parse_match( entry.read, season: season )
        end
      else
        names.each do |name|
          entry = @pack.find( name )
          SportDb.parse_match( entry.read, season: season )
        end
      end
    end


    def read( *names, season: nil )
      if names.empty?   ##  read all datafiles
        read_leagues()
        read_clubs()
        read_club_props()
        read_conf( season: season )
        read_match( season: season )
      else
        names.each do |name|
          entry = @pack.find( name )
          ## fix/todo: add read_leagues, read_clubs too!!!
          if Datafile.match_conf( name )      ## check if datafile matches conf(iguration) naming (e.g. .conf.txt)
            SportDb.parse_conf( entry.read, season: season )
          elsif Datafile.match_club_props( name )
            SportDb.parse_club_props( entry.read )
          else   ## assume "regular" match datafile
            SportDb.parse_match( entry.read, season: season )
          end
        end
      end
    end
  end   # class Package

end   # module SportDb
