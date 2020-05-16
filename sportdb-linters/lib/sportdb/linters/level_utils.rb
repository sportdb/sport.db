# encoding: utf-8


module LevelHelper ## use Helpers why? why not?

  ## todo/check: use a new DivisionHelper - why? why not?
  def division( basename )
    ## get division from basename as string
    ##  e.g. 3-liga  => 3
    ##       3a-liga => 3a
    ##       3b-liga => 3b
    ##       champs  => ?
    ##       etc.
    ##  note: only allow 1 or 01 to 99 for now
    ##  note: allow optional letter 3a,3b,3c in level for division

    if basename =~ /^[a-z]{2,3}\.(\d{1,2}[a-z]?)(?:\.|$)/    ## e.g. eng.1
      $1
    elsif basename =~ /^(\d{1,2}[a-z]?)-/
      $1   # note: returns a string
    else
      ## return ? for undefined / unknown division - why? why not?
      '?'
    end
  end

  def level( basename )
    ## get level from basename as number / integer
    ##  e.g. 3-liga, 3a-liga, 3b-liga, etc.
    ##  note: only allow 1 or 01 to 99 for now
    ##  note: allow optional letter 3a,3b,3c in level - letter gets dropped / ignored
    if basename =~ /^[a-z]{2,3}\.(\d{1,2})[a-z]?(?:\.|$)/    ## e.g. eng.1
      $1.to_i
    elsif basename =~ /^(\d{1,2})[a-z]?-/
      $1.to_i
    else
      ## return 999 for undefined / unknown level
      ##   why? let's keep the level always a number / integer (e.g. do NOT use nil or a string like '?' or  '???')
      999
    end
  end

end  # module LevelHelper


module LevelUtils
  extend LevelHelper
  ##  lets you use LevelHelper as "globals" eg.
  ##     LevelUtils.level( basename ) etc.
end # LevelUtils
