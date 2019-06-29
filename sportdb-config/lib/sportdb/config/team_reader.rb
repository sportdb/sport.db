# encoding: utf-8


module SportDb
module Import


class TeamReader

##
#  note: use our own (internal) team struct for now - why? why not?
#    - check that shape/structure/fields/attributes match
#      the Team struct in sportdb-text (in SportDb::Struct::Team)  !!!!
class Team
  ##  todo: use just names for alt_names - why? why not?
  attr_accessor :name, :alt_names, :year, :ground, :city

  def initialize
    @alt_names = []
  end
end # class Team



def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
  txt = File.open( path, 'r:utf-8' ).read
  parse( txt )
end


def self.parse( txt )
  recs = []
  last_rec  = nil

  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline (until end-of-line) comments too
    ##  e.g Eupen        => KAS Eupen,    ## [de]
    ##   => Eupen        => KAS Eupen,
    line = line.sub( /#.*/, '' ).strip
    pp line


    if line.start_with?( '|' )
      ## assume continuation with line of alternative names
      ##  note: skip leading pipe
      values = line[1..-1].split( '|' )   # team names - allow/use pipe(|)
      ## strip and  squish (white)spaces
      #   e.g. New York FC      (2011-)  => New York FC (2011-)
      values = values.map { |value| value.strip.gsub( /[ \t]+/, ' ' ) }
      last_rec.alt_names += values

      ## check for duplicates - simple check for now - fix/improve
      ## todo/fix: (auto)remove duplicates - why? why not?
      count      = last_rec.alt_names.size
      count_uniq = last_rec.alt_names.uniq.size
      if count != count_uniq
        puts
        puts "*** !!! WARN !!! - #{count-count_uniq} duplicate alt name(s):"
        pp last_rec
        ## exit 1
      end
    else
      values = line.split( ',' )

      rec = Team.new
      value = values.shift    ## get first item
      ## strip and  squish (white)spaces
      #   e.g. New York FC      (2011-)  => New York FC (2011-)
      value = value.strip.gsub( /[ \t]+/, ' ' )
      rec.name = value   # canoncial_name

      ## note:
      ##   check/todo!!!!!!!!!!!!!!!!!-
      ##  strip year if to present e.g. (2011-)
      ##
      ##  do NOT strip for defunct / historic clubs e.g.
      ##    (1899-1910)
      ## or (-1914) or (-2011) etc.

      ###
      ##  todo: move year out of canonical team name - why? why not?

      ## check if canonical name include (2011-) or similar in name
      ##   if yes, remove (2011-) and add to (alt) names
      ##   e.g. New York FC (2011) => New York FC
      if rec.name =~ /\(.+?\)/   ## note: use non-greedy (?) match
        name = rec.name.gsub( /\(.+?\)/, '' ).strip
        rec.alt_names << name
      end


      ##  todo/check - check for unknown format values
      ##    e.g. too many values, duplicate years, etc.
      ##         check for overwritting, etc.
      while values.size > 0
        value = values.shift
        ##  strip and squish (white)spaces
        #   e.g. León     › Guanajuato     => León › Guanajuato
        value = value.strip.gsub( /[ \t]+/, ' ' )
        if value =~/^\d{4}$/   # e.g 1904
          rec.year  = value.to_i
        elsif value.start_with?( '@' )   # e.g. @ Anfield
          ## cut-off leading @ and spaces
          rec.ground  = value[1..-1].strip
        else
          ## assume city / geo tree
          rec.city = value
        end
      end

      last_rec = rec


    ### todo/fix:
    ##  auto-add alt name with dots stripped - why? why not?
    ##    e.g.  D.C. United    => DC United
    ##    e.g.  Liverpool F.C. => Liverpool FC
    ##    e.g.  St. Albin       => St Albin etc.
    ##    e.g.  1. FC Köln     => 1 FC Köln  -- make special case for 1. - why? why not?

    ##
    ## todo/fix:  unify mapping entries
    ##   always lowercase !!!!  (case insensitive)
    ##   always strip (2011-) !!!
    ##   always strip dots (e.g. St., F.C, etc.)

      recs << rec
    end
  end  # each_line
  recs
end  # method read
end  # class TeamReader


end ## module Import
end ## module SportDb
