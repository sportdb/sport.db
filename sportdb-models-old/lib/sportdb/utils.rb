# encoding: utf-8

### note: some utils moved to worldbdb/utils for reuse


####
## move to folder matcher(s)/finder(s)
#  -- rename to FixtureFinder or FixtureFinders
#  or just GeneralFinder
#   TeamFinder etc.  ???


module SportDb
  module FixtureHelpers


  def cut_off_end_of_line_comment!( line )
    #  cut off (that is, remove) optional end of line comment starting w/ #

    line.sub!( /#.*$/ ) do |_|
      logger.debug "   cutting off end of line comment - >>#{$&}<<"
      ''
    end

    # NB: line = line.sub  will NOT work - thus, lets use line.sub!
  end


  def find_nationality!( line )
    # extract optional nationality - three-letter country code from line e.g.  Lionel Messi (ARG)
    # and return it
    # NB: side effect - removes num from line string

    regex = /\(([A-Z]{3})\)/     # e.g. (ARG)
    if line =~ regex
      logger.debug "   nationality: >#{$1}<"

      line.sub!( regex, '[NATIONALITY]' )
      return $1.to_s
    else
      return nil
    end
  end


  def find_leading_num!( line )
    # extract optional leading num from line   e.g.   9 Lionel Messi
    # and return it
    # NB: side effect - removes num from line string

    # e.g.  9  Lionel Messi   - must start line
    ## note: use lookahead (?=) for trailing spaces - do NOT cosume
    regex = /^[ \t]*(\d{1,3})(?=[ \t]+)/
    if line =~ regex
      logger.debug "   num: >#{$1}<"

      line.sub!( regex, '[NUM]' )
      return $1.to_i
    else
      return nil
    end
  end

  def find_leading_pos!( line )
    # extract optional game pos from line
    # and return it
    # NB: side effect - removes pos from line string

    # e.g.  (1)   - must start line 
    regex = /^[ \t]*\((\d{1,3})\)[ \t]+/
    if line =~ regex
      logger.debug "   pos: >#{$1}<"

      line.sub!( regex, '[POS] ' ) # NB: add trailing space
      return $1.to_i
    else
      return nil
    end
  end

  def find_game_pos!( line )
    ## fix: add depreciation warning - remove - use find_leading_pos!
    find_leading_pos!( line )
  end



  end # module FixtureHelpers
end # module SportDb
