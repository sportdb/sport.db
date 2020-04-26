# encoding: utf-8

module SportDb
  module Import


class WikiIndex

  def self.build( path )
    recs = []
    datafiles = Datafile.find_clubs_wiki( path )
    datafiles.each do |datafile|
        recs += WikiReader.read( datafile )
    end
    recs

    self.new( recs )
  end


  include NameHelper
  ## e.g. strip_lang, strip_year, normalize

  ## fix/todo:
  ##  also used / duplicated in ClubIndex#add_wiki !!!
  def strip_wiki( name )     # todo/check: rename to strip_wikipedia_en - why? why not?
    ## note: strip disambiguationn qualifier from wikipedia page name if present
    ##        note: only remove year and foot... for now
    ## e.g. FC Wacker Innsbruck (2002) => FC Wacker Innsbruck
    ##      Willem II (football club)  => Willem II
    ##
    ## e.g. do NOT strip others !! e.g.
    ##   América Futebol Clube (MG)
    ##  only add more "special" cases on demand (that, is) if we find more
    name = name.gsub( /\([12][^\)]+?\)/, '' ).strip  ## starting with a digit 1 or 2 (assuming year)
    name = name.gsub( /\(foot[^\)]+?\)/, '' ).strip  ## starting with foot (assuming football ...)
    name
  end


  def initialize( recs )
    @pages_by_country = {}

    ## todo/fix:
    ##   check for duplicate recs - report and exit on dupliate!!!!!!
    recs.each do |rec|
      h = @pages_by_country[ rec.country.key ] ||= {}
      h[ normalize( strip_wiki( rec.name )) ] = rec
    end
  end


  def find_by( club: )    ## todo/check: use find_by_club - why? why not?
    find_by_club( club )
  end

  def find_by_club( club )
    rec = nil

    ## get query params from club
    names   = [club.name]+club.alt_names
    country_key = club.country.key

    h = @pages_by_country[ country_key ]
    if h
      ## todo/check: sort names ?
      ##   sort by longest first (for best match)
      names.each do |name|
        ## note: normalize AND sanitize (e.g. remove/string year and lang e.g. (1946-2001), [en] too)
        rec = h[ normalize( strip_year( strip_lang( name ))) ]
        break if rec   ## bingo!! found - break on first match
      end
    end

    rec  ## note: return nil if nothing found
  end
end  # class WikiIndex


end   # module Import
end   # module SportDb
