

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
   ##      1x1 1X1           - "brazil - português / portuguese" style

   ## note: add unicode "fancy" dash too (e.g. –)
   ## add some more - why? why not?

   if m=SCORE_SPLIT_RE.match(str)
     [m[1].to_i, m[2].to_i]
   else
     # no match - warn if str is NOT empty? why? why not?

     if str.empty? || ['-', '-:-', '?'].include?( str )
       ## do NOT warn for known "good" empty scores for now - why? why not?
       ##   add some more?? use Score.empty? or such - why? why not?
     else
       puts "!! WARN - cannot match (split) score format >#{str}<"
     end

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

 alias_method :full_time,  :ft 
 alias_method :half_time,  :ht 
 alias_method :extra_time, :et 
 alias_method :penalties,  :p     ## penalties - use a different word(ing)? why? why not?
  
 ## todo/check: allow one part missing why? why not?
 ##   e.g.  1-nil  or nil-1  - why? why not?
 def ft?()  @score1   && @score2;   end
 def ht?()  @score1i  && @score2i;  end
 def et?()  @score1et && @score2et; end
 def p?()   @score1p  && @score2p;  end
 alias_method :pen?, :p?

 alias_method :full_time?,  :ft? 
 alias_method :half_time?,  :ht? 
 alias_method :extra_time?, :et? 
 alias_method :penalties?,  :p? 
 

 def initialize( *values )
   ## note: for now always assumes integers
   ##  todo/check - check/require integer args - why? why not?

   ### todo/fix: add more init options
   ##   allow kwargs (keyword args) via hash - why? why not?
   ##     use kwargs for "perfect" init where you can only set the half time (ht) score
   ##          or only the penalty or other "edge" cases
   ##   allow int pairs e.g. [1,2], [2,2]
   ##   allow values array MUST be of size 8 (or 4 or 6) - why? why not?

   raise ArgumentError, "expected even integer number (pairs), but got #{values.size}"   if values.size % 2 == 1

   if values.size == 2
     @score1   = values[0]    # full time (ft) score
     @score2   = values[1]

     @score1i  = @score2i  = nil
     @score1et = @score2et = nil
     @score1p  = @score2p  = nil
   else
     @score1i  = values[0]    # half time (ht) score
     @score2i  = values[1]

     @score1   = values[2]    # full time (ft) score
     @score2   = values[3]

     @score1et = values[4]    # extra time (et) score
     @score2et = values[5]

     @score1p  = values[6]    # penalty (p) score
     @score2p  = values[7]
   end
 end



 def to_h( format = :default )
    case format.to_sym
    when :default, :std
      ## check/todo:  only add entries if ft, ht, etc. have values (non-null) or always - why? why not?
      h = {}
      h[:ht] = [@score1i,  @score2i]   if @score1i  || @score2i
      h[:ft] = [@score1,   @score2]    if @score1   || @score2
      h[:et] = [@score1et, @score2et]  if @score1et || @score2et
      h[:p]  = [@score1p,  @score2p]   if @score1p  || @score2p
      h
    when :db
      ## use a "flat" structure with "internal" std names
      { score1i:  @score1i,   score2i:  @score2i,
        score1:   @score1,    score2:   @score2,
        score1et: @score1et,  score2et: @score2et,
        score1p:  @score1p,   score2p:  @score2p
      }
    else
      puts "!! ERROR: unknown score to_h format >#{format}<"
      exit 1
    end
 end


 def values
   ## todo/ fix: always return complete array
   ##  e.g. [score1i, score2i, score1, score2, score1et, score2et, score1p, score2p]

   ## todo: how to handle game w/o extra time
   #   but w/ optional penalty ???  e.g. used in copa liberatores, for example
   #    retrun 0,0 or nil,nil for extra time score ?? or -1, -1 ??
   #    for now use nil,nil
   score = []
   score += [@score1i,  @score2i]     if @score1p || @score2p || @score1et || @score2et || @score1 || score2 || score1i || score2i
   score += [@score1,   @score2]      if @score1p || @score2p || @score1et || @score2et || @score1 || score2
   score += [@score1et, @score2et]    if @score1p || @score2p || @score1et || @score2et
   score += [@score1p,  @score2p]     if @score1p || @score2p
   score
 end

 def to_a
   ## pairs with values
   pairs = []
   ## note: allow 1-nil, nil-1 for now in pairs (or use && and NOT ||) - why? why not?
   pairs << [@score1i,  @score2i]   if @score1i  || @score2i
   pairs << [@score1,   @score2]    if @score1   || @score2
   pairs << [@score1et, @score2et]  if @score1et || @score2et
   pairs << [@score1p,  @score2p]   if @score1p  || @score2p

   if pairs.empty?
     pairs   # e.g. return []
   elsif pairs.size == 1
     pairs[0]  # return single pair "unwrapped" e.g. [0,1] instead of [[0,1]] - why? why not?
   else
     pairs
   end
 end

end  # class Score


