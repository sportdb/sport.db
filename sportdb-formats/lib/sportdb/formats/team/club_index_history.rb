# encoding: utf-8

module SportDb
  module Import


class ClubHistoryIndex

  def self.build( path )
    pack = Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_clubs_history do |entry|
      recs += ClubHistoryReader.parse( entry.read )
    end
    recs

    index = new
    index.add( recs )
    index
  end



  def catalog() Import.catalog; end

  ## note: keep name history for now separate from
  ##          from club struct - why? why not?
  ##       later yes, yes, yes, merge name history into club struct!!!!!
  ##
  ## for now the name history is experimental


  def initialize
    @clubs          = {}   ## clubs (indexed) by canonical name
    @errors         = []
  end

  attr_reader :errors
  def errors?() @errors.empty? == false; end

  def mappings() @clubs; end   ## todo/check: rename to records or histories or something - why? why not?


  def add_history( club_rec, keyword, season, args )
    ## note use season obj for now (and NOT key) - why? why not?
    rec = @clubs[ club_rec.name ] ||= []

    rec << [season, [keyword, args]]

    ## note: always keep records sorted by season_key for now
    ##   check if 2010 and 2010/11 is in order using alpha sort?? (see argentina)
    rec.sort! { |l,r| r[0] <=> l[0] }
  end


  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|

      keyword    = rec[0]
      season_key = rec[1]
      args       = rec[2..-1]   ## get rest of args e.g. one, two or more

      ## note: for now only add (re)name history season records,
      ##          that is, skip MERGE and BANKRUPT for now
      ##           and incl. only RENAME, REFORM, MOVE for now
      next if ['MERGE', 'BANKRUPT'].include?( keyword )


      name_old = strip_geo( args[0][0] )  ## note: strip optional geo part from name
      name_new = strip_geo( args[1][0] )

      country_old = args[0][1]
      country_new = args[1][1]

      club_old = catalog.clubs.find_by!( name: name_old, country: country_old )
      club_new = catalog.clubs.find_by!( name: name_new, country: country_new )

      ## note use season obj for now (and NOT key) - why? why not?
      season = Season.new( season_key )

      ## todo/check:
      ##   check if  club_old and club_new reference different club record!!
      ##    examples - RB II            -> Liefering ??  or
      ##               FC Pasching      -> OOE Juniors ??
      ##               Austria Salzburg -> RB Salburg ??
      ##   for now always add name history to both - why? why not?

      add_history( club_old, keyword, season, args )
      ## note: allow for now different club references
      ##    but maybe warn later - why? why not?
      ## add history to both for now
      add_history( club_new, keyword, season, args )  if club_old != club_new
    end # each rec
  end # method add


  #### todo/check: move as method to club struct later - to always use club reference
  ##  returns (simply) name as string for now or nil - why? why not?
  #
  #  history entry example
  # Arsenal FC"=>
  # [[1927/28, ["RENAME", [["The Arsenal FC, London", "eng"], ["Arsenal FC", "eng"]]]],
  #  [1914/15, ["RENAME", [["Woolwich Arsenal FC, London", "eng"], ["The Arsenal FC", "eng"]]]],
  #  [1892/93, ["RENAME", [["Royal Arsenal FC, London", "eng"], ["Woolwich Arsenal FC", "eng"]]]]],
  def find_name_by( name:, season: )
    recs = @clubs[ name ]
    if recs
      season = season( season )   ## make sure season is a season obj (and NOT a string)
      ## check season records for name; use linear search (assume only few records)
      recs.each do |rec|
        if season >= rec[0]
           return strip_geo( rec[1][1][1][0] )  # use second arg
        end
      end
      ## if we get here use last name
      strip_geo( recs[-1][1][1][0][0] )   # use first arg
    else
      nil
    end
  end

  ##################
  ## helpers
  def season( season )
    season.is_a?( Season ) ? season : Season.new( season )
  end

  def strip_geo( name )
    ## e.g. Arsenal, London   =>   Arsenal
    name.split(',')[0].strip
  end
end # class ClubHistoryIndex

end   # module Import
end   # module SportDb
