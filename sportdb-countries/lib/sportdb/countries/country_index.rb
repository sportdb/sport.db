# encoding: utf-8

module SportDb
module Import

## built-in countries for (quick starter) auto-add
class CountryIndex

  def initialize( recs )
    @countries         = []
    @countries_by_code = {}

    add( recs )
  end

  def add( recs )
    ###########################################
    ## auto-fill countries
    ## pp recs
    recs.each do |rec|
      ## rec e.g. { key:'af', fifa:'AFG', name:'Afghanistan'}

      @countries << rec

      ## add codes lookups - key, fifa, ...
      if @countries_by_code[ rec.key ]
        puts "** !! ERROR !! country code (key) >#{rec.key}< already exits!!"
        exit 1
      else
        @countries_by_code[ rec.key ] = rec
      end

      ## add fifa code (only) if different from key
      if rec.key != rec.fifa.downcase
        if @countries_by_code[ rec.fifa.downcase ]
          puts "** !! ERROR !! country code (fifa) >#{rec.fifa.downcase}< already exits!!"
          exit 1
        else
          @countries_by_code[ rec.fifa.downcase ] = rec
        end
      end
    end
  end # method initialize

  def []( key )
    key = key.to_s.downcase   ## allow symbols (and always downcase e.g. AUT to aut etc.)
    @countries_by_code[ key ]
  end
end # class CountryIndex


end   # module Import
end   # module SportDb
