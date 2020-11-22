
### note: make Season like Date a "top-level" / "generic" class


class Season
  ##
  ##  todo: add (optional) start_date and end_date - why? why not?

  ## todo/todo/todo/check/check/check !!!
  ## todo: add a kernel Seaons e.g. Season('2011/12')
  ##    forward to Season.convert( *args )  - why? why not?

  ## todo: add unicode - too - why? why not? see wikipedia pages, for example

  YYYY_YYYY_RE  = %r{^      ## e.g. 2011-2012 or 2011/2012
                    (\d{4})
                      [/-]
                    (\d{4})
                   $
                  }x
  YYYY_YY_RE  = %r{^       ## e.g. 2011-12 or 2011/12
                    (\d{4})
                      [/-]
                    (\d{2})
                   $
                  }x
  YYYY_Y_RE  = %r{^       ## e.g. 2011-2 or 2011/2
                  (\d{4})
                    [/-]
                  (\d{1})
                 $
                }x
  YYYY_RE     = %r{^       ## e.g. 2011
                    (\d{4})
                   $
                  }x


  def self.parse( str )
    new( *_parse( str ))
  end

  def self._parse( str )   ## "internal" parse helper
    if str =~ YYYY_YYYY_RE    ## e.g. 2011/2012
      [$1.to_i, $2.to_i]
    elsif str =~ YYYY_YY_RE   ## e.g. 2011/12
      fst = $1.to_i
      snd = $2.to_i
      snd_exp = '%02d' % [(fst+1) % 100]    ## double check: e.g 00 == 00, 01==01 etc.
      raise ArgumentError, "[Season.parse] invalid year in season >>#{str}<<; expected #{snd_exp} but got #{$2}"   if snd_exp != $2
      [fst, fst+1]
    elsif str =~ YYYY_Y_RE    ## e.g. 2011/2
      fst = $1.to_i
      snd = $2.to_i
      snd_exp = '%d' % [(fst+1) % 10]      ## double check: e.g 0 == 0, 1==1 etc.
      raise ArgumentError, "[Season.parse] invalid year in season >>#{str}<<; expected #{snd_exp} but got #{$2}"   if snd_exp != $2
      [fst, fst+1]
    elsif str =~ YYYY_RE      ## e.g. 2011
      [$1.to_i]
    else
      raise ArgumentError, "[Season.parse] unkown season format >>#{str}<<; sorry cannot parse"
    end
  end


  def self.convert( *args )  ## note: used by Kernel method Season()
    if args.size == 1 && args[0].is_a?( Season )
      args[0]  # pass through / along as is 1:1
    elsif args.size == 1 && args[0].is_a?( String )
      parse( args[0] )
    elsif args.size == 1 && args[0].is_a?( Integer ) && args[0] > 9999
      ## note: allow convenience "hack" such as:
      # 202021   or 2020_21   => '2020/21' or
      # 2020_1   or 2020_1    => '2020/21' or
      # 20202021 or 2020_2021 => '2020/21'
      str = args[0].to_s
      parse( "#{str[0..3]}/#{str[4..-1]}" )
    else ## assume all integer args e.g.  2020 or 2020, 2021 and such
      new( *args ) ## try conversion with new
    end
  end


  attr_reader :start_year,
              :end_year

  def initialize( *args )   ## change args to years - why? why not?
    if args.size == 1 && args[0].is_a?( Integer )
      @start_year = args[0]
      @end_year   = args[0]
    elsif args.size == 2 && args[0].is_a?( Integer ) &&
                            args[1].is_a?( Integer )
      @start_year = args[0]
      @end_year   = args[1]
      end_year_exp = @start_year+1
      raise ArgumentError, "[Season] invalid year in season >>#{to_s}<<; expected #{end_year_exp} but got #{@end_year}"   if end_year_exp != @end_year
    else
      pp args
      raise ArgumentError, "[Season] expected season start year (integer) with opt. end year"
    end
  end



  ## single-year season e.g. 2011 if start_year is end_year - todo - find a better name?
  def calendar_year?()  @start_year == @end_year; end
  alias_method :calendar?, :calendar_year?
  alias_method :year?,     :calendar_year?

  def academic_year?() !calenar_year?; end
  alias_method :academic?, :academic_year?



  def prev
    if year?
      Season.new( @start_year-1 )
    else
      Season.new( @start_year-1, @end_year-1 )
    end
  end

  def next
    if year?
      Season.new( @start_year+1 )
    else
      Season.new( @start_year+1, @end_year+1 )
    end
  end
  alias_method :succ, :next   ## add support for ranges


  include Comparable
  def <=>(other)
    ## todo/fix/fix:  check if other is_a?( Season )!!!
    ##  what to return if other type/class ??
    ## note: check special edge case - year season and other e.g.
    ##    2010 <=> 2010/2011

    res = @start_year <=> other.start_year
    res = @end_year   <=> other.end_year     if res == 0
    res
  end


  def to_formatted_s( format=:default, sep: '/' )
    if year?
      '%d' % @start_year
    else
      case format
      when :default, :short, :s   ## e.g. 1999/00 or 2019/20
        "%d#{sep}%02d" % [@start_year, @end_year % 100]
      when :long, :l              ## e.g. 1999/2000 or 2019/2020
        "%d#{sep}%d" % [@start_year, @end_year]
      else
        raise ArgumentError, "[Season.to_s] unsupported format >#{format}<"
      end
    end
  end
  alias_method :to_s, :to_formatted_s

  def key()  to_s( :short ); end
  alias_method :to_key,  :key
  alias_method :name,    :key
  alias_method :title,   :key

  alias_method :inspect, :key  ## note: add inspect debug support change debug output to string!!



  def to_path( format=:default )
    case format
    when :default, :short, :s    ## e.g. 1999-00 or 2019-20
      to_s( :short, sep: '-' )
    when :long, :l                ## e.g. 1999-2000 or 2019-2000
      to_s( :long, sep: '-' )
    when :archive, :decade, :d    ## e.g. 1990s/1999-00 or 2010s/2019-20
      "%3d0s/%s" % [@start_year / 10, to_s( :short, sep: '-' )]
    when :century, :c             ## e.g. 1900s/1990-00 or 2000s/2019-20
      "%2d00s/%s" % [@start_year / 100, to_s( :short, sep: '-' )]
    else
      raise ArgumentError, "[Season.to_path] unsupported format >#{format}<"
    end
  end # method to_path
  alias_method :directory, :to_path   ## keep "legacy" directory alias - why? why not?
  alias_method :path,      :to_path



  #########################################
  ## more convenience helper  - move to sportdb or such - remove - why - why not???
  def start_date   ## generate "generic / syntetic start date" - keep helper - why? why not?
    if year?
      Date.new( start_year, 1, 1 )
    else
      Date.new( start_year 1, 7 )
    end
  end


end # class Season



### note: add a convenience "shortcut" season kernel method conversion method
##  use like Season( '2012/3' )  or such
module Kernel
  def Season( *args ) Season.convert( *args ); end
end