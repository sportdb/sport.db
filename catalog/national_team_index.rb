
module SportDb
  module Import

class NationalTeamIndex

  attr_reader :teams     ## all (national) team records

  def initialize( recs )
    @teams         = []
    @teams_by_code = {}
    @teams_by_name = {}

    add( recs )
  end

  include NameHelper
  ## incl. strip_year( name )
  ##       has_year?( name)
  ##       strip_lang( name )
  ##       normalize( name )


  def add( recs )
    ###########################################
    ## auto-fill national teams
    ## pp recs
    recs.each do |rec|
      @teams << rec

      ## add fifa code lookup
      if @teams_by_code[ rec.code.downcase ]
        puts "** !! ERROR !! national team code (code) >#{rec.code}< already exits!!"
        exit 1
      else
        @teams_by_code[ rec.code.downcase ] = rec
      end


      ##  add all names (canonical name + alt names
      names = [rec.name] + rec.alt_names
      more_names = []
      ## check "hand-typed" names for year (auto-add)
      ## check for year(s) e.g. (1887-1911), (-2013),
      ##                        (1946-2001,2013-) etc.
      names.each do |name|
        if has_year?( name )
          more_names <<  strip_year( name )
        end
      end

      names += more_names
      ## check for duplicates - simple check for now - fix/improve
      ## todo/fix: (auto)remove duplicates - why? why not?
      count      = names.size
      count_uniq = names.uniq.size
      if count != count_uniq
        puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s) in national teams:"
        pp names
        pp rec
        exit 1
      end

      names.each_with_index do |name,i|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        name = strip_lang( name )
        norm = normalize( name )
        old_rec = @teams_by_name[ norm ]
        if old_rec
          ## check if tame name already is included or is new team rec
            msg = "** !!! ERROR !!! - national team name conflict/duplicate - >#{name}< will overwrite >#{old_rec.name}< with >#{rec.name}<"
            puts msg
            exit 1
        else
          @teams_by_name[ norm ] = rec
        end
      end
    end  ## each record
  end # method initialize

  ##  fix/todo: add  find_by (alias for find_by_name/find_by_code)
  def find_by_code( code )
    code = code.to_s.downcase   ## allow symbols (and always downcase e.g. AUT to aut etc.)
    @teams_by_code[ code ]
  end

  def find_by_name( name )
    name = normalize( name.to_s )  ## allow symbols too (e.g. use to.s first)
    @teams_by_name[ name ]
  end

  def find( q )
    ## check longest match first (assume name is longer than code)
    ## try lookup / find by (normalized) name first
    team = find_by_name( q )
    team = find_by_code( q )  if team.nil?
    team
  end

  def find!( q )
    team = find( q )
    if team.nil?
      puts "** !!! ERROR - no match for national team >#{q}< found"
      exit 1
    end
    team
  end
end   # class NationalTeamIndex


end   # module Import
end   # module SportDb

