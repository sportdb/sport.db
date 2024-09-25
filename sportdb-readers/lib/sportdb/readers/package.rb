
module SportDb
  class Package

    ## note: add readers here; for full class def see the sourcein sportdb-formats!!!
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

    ## note: read is same as read_match for now!!!
    ##         in the future add (again) more formats (see attic for history)
    alias_method :read, :read_match
  end   # class Package
end   # module SportDb
