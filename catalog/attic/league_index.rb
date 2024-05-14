# encoding: utf-8

module SportDb
  module Import

class LeagueIndex

  def self.build( path )
    pack = Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_leagues do |entry|
      recs += League.parse( entry.read )
    end
    recs

    leagues = new
    leagues.add( recs )
    leagues
  end


  def catalog() Import.catalog; end

  def initialize
    @leagues         = []   ## leagues by canonical name
    @leagues_by_name = {}
    @errors          = []
  end

  attr_reader :errors
  def errors?() @errors.empty? == false; end

  def mappings()   @leagues_by_name; end   ## todo/check: rename to index or something - why? why not?
  def leagues()    @leagues.values;  end
  alias_method :all, :leagues   ## use ActiveRecord-like alias for leagues


  ## helpers from club - use a helper module for includes - why? why not?
  include NameHelper
  ## incl. strip_lang( name )
  ##       normalize( name )


  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## puts "adding:"
      ## pp rec
      ### step 1) add canonical name
      @leagues << rec

      ## step 2) add all names (canonical name + alt names + alt names (auto))
      names = [rec.name] + rec.alt_names
      ## check for duplicates - simple check for now - fix/improve
      ## todo/fix: (auto)remove duplicates - why? why not?
      count      = names.size
      count_uniq = names.uniq.size
      if count != count_uniq
        puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s):"
        pp names
        pp rec
        exit 1
      end

      ## todo/fix: move alt_names_auto up for check unique names
      ##    e.g. remove/avoid auto-generated duplicates ENG 1, AUT 1, etc
      names += rec.alt_names_auto

      names.each_with_index do |name,i|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        name = strip_lang( name )
        norm = normalize( name )
        alt_recs = @leagues_by_name[ norm ]
        if alt_recs
          ## check if include club rec already or is new club rec
          if alt_recs.include?( rec )
            ## note: do NOT include duplicate club record
            msg = "** !!! WARN !!! - (norm) name conflict/duplicate for league - >#{name}< normalized to >#{norm}< already included >#{rec.name}, #{rec.country ? rec.country.key : '?'}<"
            puts msg
            @errors << msg
          else
            msg = "** !!! WARN !!! - name conflict/duplicate - >#{name}< will overwrite >#{alt_recs[0].name}, #{alt_recs[0].country ? alt_recs[0].country.key : '?'}< with >#{rec.name}, #{rec.country ? rec.country.key : '?'}<"
            puts msg
            @errors << msg
            alt_recs << rec
          end
        else
          @leagues_by_name[ norm ] = [rec]
        end
      end
    end
  end # method add


  ## helper to always convert (possible) country key to existing country record
  ##  todo: make private - why? why not?
  def country( country )
    if country.is_a?( String ) || country.is_a?( Symbol )
      ## note:  use own "global" countries index setting for ClubIndex - why? why not?
      rec = catalog.countries.find( country.to_s )
      if rec.nil?
        puts "** !!! ERROR !!! - unknown country >#{country}< - no match found, sorry - add to world/countries.txt in config"
        exit 1
      end
      rec
    else
      country  ## (re)use country struct - no need to run lookup again
    end
  end


  def match( name )
    ## note: returns empty array if no match and NOT nil
    name = normalize( name )
    @leagues_by_name[ name ] || []
  end

  def match_by( name:, country: )
    ## note: match must for now always include name
    m = match( name )
    if country    ## filter by country
      ## note: country assumes / allows the country key or fifa code for now
      ## note: allow passing in of country struct too
      country_rec = country( country )

      ## note: also skip international leagues & cups (e.g. champions league etc.) for now - why? why not?
      m = m.select { |league| league.country &&
                              league.country.key == country_rec.key }
    end
    m
  end


  def find!( name )
    league = find( name )
    if league.nil?
      puts "** !!! ERROR - no league match found for >#{name}<, add to leagues table; sorry"
      exit 1
    end
    league
  end

  def find( name )
    league = nil
    m = match( name )
    # pp m

    if m.empty?
      ## fall through/do nothing
    elsif m.size > 1
      puts "** !!! ERROR - ambigious league name; too many leagues (#{m.size}) found:"
      pp m
      exit 1
    else
      league = m[0]
    end

    league
  end




  def dump_duplicates # debug helper - report duplicate club name records
     @leagues_by_name.each do |name, leagues|
       if leagues.size > 1
         puts "#{leagues.size} matching leagues duplicates for >#{name}<:"
         pp leagues
       end
     end
  end
end # class LeagueIndex

end   # module Import
end   # module SportDb
