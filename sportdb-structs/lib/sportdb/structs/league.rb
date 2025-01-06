
module Sports


class LeaguePeriod
  attr_reader   :key, :name, :qname, :slug,
                :prev_name,  :start_season, :end_season

  attr_accessor :alt_names
               
  def initialize( key:, name:, qname:, slug:,
                        prev_name: nil,
                        start_season: nil, end_season: nil )
    @key = key
    @name = name
    @qname = qname
    @slug = slug
    @prev_name = prev_name
    @start_season = start_season
    @end_season  = end_season

    @alt_names = []
  end


####
## todo/fix - share code for names and codes with League and LeaguePeriod!!!
##         for now cut-n-paste copy

 #############################
  ### virtual helpers
  ##    1) codes  (returns uniq array of all codes in lowercase
  ##               incl. key, code and alt_codes in alt_names)
  ##    2) names  (returns uniq array of all names - with language tags stripped)
  ##

## note: split names into names AND codes
##      1)  key plus all lower case names are codes
##      2)    all upper case names are names AND codes
##      3)    all other names are names

## only allow asci a to z (why? why not?)
##  excludes Ö1 or such (what else?)
##   allow space and dot - why? why not?
##     e.g. HNL 1
##          NB I or NB II etc.
IS_CODE_N_NAME_RE = %r{^
                           [\p{Lu}0-9. ]+
                       $}x
## add space (or /) - why? why not?
IS_CODE_RE           = %r{^
                            [\p{Ll}0-9.]+
                        $}x


  def codes
       ## change/rename to more_codes - why? why?
       ##    get reference (tier/canonicial) codes via periods!!!!

       ## note - "auto-magically" downcase code (and code'n'name matches)!!
      ##  note - do NOT include key as code for now!!!
      ##
      ## todo/check - auto-remove space from code - why? why not?
      ##         e.g. NB I, NB II, HNL 1 => NBI, NBII, HBNL1, etc -
      codes = []
      alt_names.each do |name|
        if IS_CODE_N_NAME_RE.match?( name )
          codes << name.downcase
        elsif IS_CODE_RE.match?( name )
          codes << name
        else ## assume name
          ## do nothing - skip/ignore
        end
      end
      codes.uniq
  end


  include SportDb::NameHelper   # pulls-in strip_lang

  def names
    names = [@name]
    alt_names.each do |name|
       if IS_CODE_N_NAME_RE.match?( name )
         names << name
       elsif IS_CODE_RE.match?( name )
         ## do nothing - skip/ignore
       else ## assume name
         names <<  strip_lang( name )
       end
   end

##  report duplicate names - why? why not
     ## check for duplicates - simple check for now - fix/improve
     ## todo/fix: (auto)remove duplicates - why? why not?
     count      = names.size
     count_uniq = names.uniq.size
     if count != count_uniq
       puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s):"
       pp names
       pp self
       exit 1
     end

   names.uniq
  end


  def pretty_print( printer )
    buf = String.new
    buf << "<LeaguePeriod"
    buf << " #{@key}"
    buf << " (#{@start_season}-#{@end_season})"  if @start_season || @end_season
    buf << " -"
    buf << " #{@name}"
    if @name != @qname
       buf << " | #{@qname}"
    else
       buf << "*"
    end
    buf << ">"

    printer.text( buf )
  end
end # class LeaguePeriod


################
# todo: add a type field -
#       add a tier field - why? why not?
#   e.g.  league/cup  (or national_league, national_cup, intl_cup, etc.?)
#   e.g.  1st-tier, 2nd-tier, etc.


class League
  attr_reader   :key, :name, :country, :intl
  attr_accessor :alt_names
  attr_accessor :periods


  def initialize( key:, name:, alt_names: [],
                  country: nil, intl: false, clubs: true )
    @key            = key
    @name           = name
    @alt_names      = alt_names

    @country        = country
    @intl           = intl
    @clubs          = clubs

    @periods        = []   ## change/rename to history - why? why not?
  end


  def intl?()      @intl == true; end
  def national?()  @intl == false; end
  alias_method   :domestic?, :national?

  def clubs?()            @clubs == true; end
  def national_teams?()   @clubs == false; end
  alias_method   :club?,          :clubs?
  alias_method   :national_team?, :national_teams?


  #############################
  ### virtual helpers
  ##    1) codes  (returns uniq array of all codes in lowercase
  ##               incl. key, code and alt_codes in alt_names)
  ##    2) names  (returns uniq array of all names - with language tags stripped)
  ##

## note: split names into names AND codes
##      1)  key plus all lower case names are codes
##      2)    all upper case names are names AND codes
##      3)    all other names are names

## only allow asci a to z (why? why not?)
##  excludes Ö1 or such (what else?)
##   allow space and dot - why? why not?
##     e.g. HNL 1
##          NB I or NB II etc.
IS_CODE_N_NAME_RE = %r{^
                           [\p{Lu}0-9. ]+
                       $}x
## add space (or /) - why? why not?
IS_CODE_RE           = %r{^
                            [\p{Ll}0-9.]+
                        $}x


  def codes
       ## change/rename to more_codes - why? why?
       ##    get reference (tier/canonicial) codes via periods!!!!

       ## note - "auto-magically" downcase code (and code'n'name matches)!!
      ##  note - do NOT include key as code for now!!!
      ##
      ## todo/check - auto-remove space from code - why? why not?
      ##         e.g. NB I, NB II, HNL 1 => NBI, NBII, HBNL1, etc -
      codes = []
      alt_names.each do |name|
        if IS_CODE_N_NAME_RE.match?( name )
          codes << name.downcase
        elsif IS_CODE_RE.match?( name )
          codes << name
        else ## assume name
          ## do nothing - skip/ignore
        end
      end
      codes.uniq
  end


  include SportDb::NameHelper   # pulls-in strip_lang

  def names
    names = [@name]
    alt_names.each do |name|
       if IS_CODE_N_NAME_RE.match?( name )
         names << name
       elsif IS_CODE_RE.match?( name )
         ## do nothing - skip/ignore
       else ## assume name
         names <<  strip_lang( name )
       end
   end

##  report duplicate names - why? why not
     ## check for duplicates - simple check for now - fix/improve
     ## todo/fix: (auto)remove duplicates - why? why not?
     count      = names.size
     count_uniq = names.uniq.size
     if count != count_uniq
       puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s):"
       pp names
       pp self
       exit 1
     end

   names.uniq
  end


=begin
 @alt_names=[],
  @clubs=true,
  @country=<Country: at - Austria (AUT)|Österreich [de], fifa|uefa)>,
  @intl=false,
  @key="at.1",
  @name="Bundesliga">,
=end

  def pretty_print( printer )
    buf = String.new
    buf << "<League"
    buf << " INTL"   if @intl
    buf <<   if @clubs
                 " CLUBS"
             else
                 " NATIONAL TEAMS"
             end
    buf << ": #{@name}"

    if @alt_names && !@alt_names.empty?
      buf << "|"
      buf << @alt_names.join('|')
    end

    buf << ", #{@country.name} (#{@country.code})"     if @country

    if @periods && !@periods.empty?
      buf << ", "
      buf << @periods.map{|period| period.key }.uniq.join('|')
    end
    buf << ">"

    printer.text( buf )
  end
end   # class League


end   # module Sports
