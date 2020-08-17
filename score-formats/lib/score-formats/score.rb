

## note: make Score top-level and use like Date - yes, yes, yes - why? why not?
class Score

  SCORE_SPLIT_RE = %r{^  [ ]*
                        ([0-9]+)
                         [ ]*
                         [:x–-]      ## note: allow some unicode dashes too
                         [ ]*
                        ([0-9]+)
                         [ ]*  $}xi

 def self.split( str )   ## note: return array of two integers or empty array
   ## e.g. allow/support
   ##      1-1 or 1 - 1      - "english" style
   ##      1:1               - "german / deutsch" style
   ##      1x1 1X1           - "brazil/portugese" style

   ## note: add unicode "fancy" dash too (e.g. –)
   ## add some more - why? why not?

   if m=SCORE_SPLIT_RE.match(str)
     [m[1].to_i, m[2].to_i]
   else
     # no match - warn if str is not empty? why? why not?
     ##
     ## todo/fix:
     ## do NOT warn on
     ##    assert_equal [], Score.split( '-' )
     ##    assert_equal [], Score.split( '-:-' )
     ##    assert_equal [], Score.split( '?' )
     ## for now - add more?

     puts "!! WARN - cannot match (split) score format >#{str}<"  unless str.empty?
     []
   end
 end




 attr_reader :score1i,  :score2i,   # half time (ht) score
             :score1,   :score2,    # full time (ft) score
             :score1et, :score2et,  # extra time (et) score
             :score1p,  :score2p    # penalty (p) score
             ## todo/fix: add :score1agg, score2agg too - why? why not?!!!
             ##  add state too e.g. canceled or abadoned etc - why? why not?

 ## alternate accessor via array e.g. ft[0] and ft[1]
 def ft()  [@score1,   @score2];   end  ## e.g. 90 mins (in football)
 def ht()  [@score1i,  @score2i];  end  ## e.g. 45 mins
 def et()  [@score1et, @score2et]; end  ## e.g. 90+15mins
 def p()   [@score1p,  @score2p];  end  ## e.g. note - starts "fresh" score from 0-0
 alias_method :pen, :p   ## add alias - why? why not?

 def ft?()  @score1   && @score2;   end
 def ht?()  @score1i  && @score2i;  end
 def et?()  @score1et && @score2et; end
 def p?()   @score1p  && @score2p;  end
 alias_method :pen?, :p?



 def initialize( *values )
   ## note: for now always assumes integers
   ##  todo/check - check/require integer args - why? why not?

   ## if values.size == 2
   ###  @score1   = values[2]    # full time (ft) score
   ##  @score2   = values[3]
   ##  - add why? why not?

     @score1i  = values[0]    # half time (ht) score
     @score2i  = values[1]

     @score1   = values[2]    # full time (ft) score
     @score2   = values[3]

     @score1et = values[4]    # extra time (et) score
     @score2et = values[5]

     @score1p  = values[6]    # penalty (p) score
     @score2p  = values[7]
 end

 def to_a
   ## todo: how to handle game w/o extra time
   #   but w/ optional penalty ???  e.g. used in copa liberatores, for example
   #    retrun 0,0 or nil,nil for extra time score ?? or -1, -1 ??
   #    for now use nil,nil
   score = []
   score += [score1i,  score2i]     if score1p || score2p || score1et || score2et || score1 || score2 || score1i || score2i
   score += [score1,   score2]      if score1p || score2p || score1et || score2et || score1 || score2
   score += [score1et, score2et]    if score1p || score2p || score1et || score2et
   score += [score1p,  score2p]     if score1p || score2p
   score
 end

end  # class Score


