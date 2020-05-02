# encoding: utf-8


module SportDb
  module Import


class Season
  ##
  ##  todo: add (optional) start_date and end_date - why? why not?
  ##        add next


  attr_reader :start_year,
              :end_year

  def year?()  @end_year.nil?; end  ## single-year season e.g. 2011 if no end_year present


  def initialize( str )   ## assume only string / line gets passed in for now
    @start_year, @end_year = parse( str )
  end


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

  def parse( str )
    if str =~ YYYY_YYYY_RE    ## e.g. 2011/2012
      [$1.to_i, $2.to_i]
    elsif str =~ YYYY_YY_RE   ## e.g. 2011/12
      fst = $1.to_i
      snd = $2.to_i
      snd_exp = '%02d' % [(fst+1) % 100]    ## double check: e.g 00 == 00, 01==01 etc.
      raise ArgumentError.new( "[Season#parse] invalid year in season >>#{str}<<; expected #{snd_exp} but got #{$2}")   if snd_exp != $2
      [fst, fst+1]
    elsif str =~ YYYY_Y_RE    ## e.g. 2011/2
      fst = $1.to_i
      snd = $2.to_i
      snd_exp = '%d' % [(fst+1) % 10]      ## double check: e.g 0 == 0, 1==1 etc.
      raise ArgumentError.new( "[Season#parse] invalid year in season >>#{str}<<; expected #{snd_exp} but got #{$2}")   if snd_exp != $2
      [fst, fst+1]
    elsif str =~ YYYY_RE      ## e.g. 2011
      [$1.to_i]
    else
      raise ArgumentError.new( "[Season#parse] unkown season format >>#{str}<<; sorry cannot parse")
    end
  end



  def prev
    if year?
      Season.new( "#{@start_year-1}" )
    else
      Season.new( "#{@start_year-1}/#{@start_year}" )
    end
  end

  def key
    if year?
      '%d' % @start_year
    else
      '%d/%02d' % [@start_year, @end_year % 100]
    end
  end
  alias_method :to_key, :key
  alias_method :to_s,   :key

  alias_method :name,   :key
  alias_method :title,  :key


  def path( format: nil )
    ##  todo: find better names for formats - why? why not?:
    ##    long | archive | decade(?)   =>   1980s/1988-89, 2010s/2017-18, ...
    ##    short | std(?)   =>   1988-89, 2017-18, ...

    ## convert season name to "standard" season name for directory

    if ['l', 'long', 'archive' ].include?( format.to_s )   ## note: allow passing in of symbol to e.g. 'long' or :long
      if year?   ## e.g. 2000s/2001
        "%3d0s/%4d" % [@start_year / 10, @start_year]
      else       ## e.g. 2000s/2001-02
        "%3d0s/%4d-%02d" % [@start_year / 10, @start_year, @end_year % 100]
      end
    else  ## default 'short' format / fallback
      if year?   ## e.g. 2001
        "%4d" % @start_year
      else       ## e.g. 2001-02
        "%4d-%02d" % [@start_year, @end_year % 100]
      end
    end
  end # method path
  alias_method :directory, :path   ## keep "legacy" directory alias - why? why not?
  alias_method :to_path,   :path


end # class Season


end  # module Import
end  # module SportDb
