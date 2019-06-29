# encoding: utf-8


module SeasonHelper ## use Helpers why? why not?
  def prev( season )
    ## todo: add 1964-1965 format too!!!
    if season =~ /^(\d{4})-(\d{2})$/    ## season format is  1964-65
      fst = $1.to_i - 1
      snd = (100 + $2.to_i - 1) % 100    ## note: add 100 to turn 00 => 99
      "%4d-%02d" % [fst,snd]
    elsif season =~ /^(\d{4})$/
      fst = $1.to_i - 1
      "%4d" % [fst]
    else
      puts "*** !!!! wrong season format >>#{season}<<; exit; sorry"
      exit 1
    end
  end  # method prev


  def key( basename )
    if basename =~ /^(\d{4})[\-\/](\d{4})$/      ## e.g. 2011-2012 or 2011/2012 => 2011/12
      "%4d/%02d" % [$1.to_i, $2.to_i % 100]
    elsif basename =~ /^(\d{4})[\-\/](\d{2})$/   ## e.g. 2011-12 or 2011/12  => 2011/12
      "#{$1}/#{$2}"
    elsif basename =~ /^(\d{4})$/
      $1
    else
      puts "*** !!!! wrong season format >>#{basename}<<; exit; sorry"
      exit 1
    end
  end  # method key


  def directory( season, format: nil )
    ##  todo: find better names for formats - why? why not?:
    ##    long | archive | decade(?)   =>   1980s/1988-89, 2010s/2017-18, ...
    ##    short | std(?)   =>   1988-89, 2017-18, ...

    ## convert season name to "standard" season name for directory

    ## todo/fix: move to parse / validate season (for (re)use)!!!! - why? why not?
    if season =~ /^(\d{4})[\-\/](\d{4})$/   ## e.g. 2011-2012 or 2011/2012 => 2011-12
      years = [$1.to_i, $2.to_i]
    elsif season =~ /^(\d{4})[\-\/](\d{2})$/   ## e.g. 2011-12 or 2011/12  => 2011-12
      years = [$1.to_i, $1.to_i+1]
      ## note: check that season end year is (always) season start year + 1
      if ($1.to_i+1) % 100 != $2.to_i
        puts "*** !!!! wrong season format >>#{season}<<; season end year MUST (always) equal season start year + 1; exit; sorry"
        exit 1
      end
    elsif season =~ /^(\d{4})$/
      years = [$1.to_i]
    else
      puts "*** !!!! wrong season format >>#{season}<<; exit; sorry"
      exit 1
    end


    if ['l', 'long', 'archive' ].include?( format.to_s )   ## note: allow passing in of symbol to e.g. 'long' or :long
      if years.size == 2
        "%3d0s/%4d-%02d" % [years[0] / 10, years[0], years[1] % 100]   ## e.g. 2000s/2001-02
      else  ## assume size 1 (single year season)
        "%3d0s/%4d" % [years[0] / 10, years[0]]
      end
    else  ## default 'short' format / fallback
      if years.size == 2
        "%4d-%02d" % [years[0], years[1] % 100]   ## e.g. 2001-02
      else  ## assume size 1 (single year season)
        "%4d" % years[0]
      end
    end
  end # method directory



  def start_year( season ) ## get start year
    ## convert season name to "standard" season name for directory

    ## todo/check:  just return year from first for chars - keep it simple - why? why not?
    if season =~ /^(\d{4})[\-\/](\d{4})$/   ## e.g. 2011-2010 or 2011/2011 => 2011-10
      $1
    elsif season =~ /^(\d{4})[\-\/](\d{2})$/
      $1
    elsif season =~ /^(\d{4})$/
      $1
    else
      puts "*** !!!! wrong season format >>#{season}<<; exit; sorry"
      exit 1
    end
  end

  def end_year( season ) ## get end year
    ## convert season name to "standard" season name for directory
    if season =~ /^(\d{4})[\-\/](\d{4})$/   ## e.g. 2011-2010 or 2011/2011 => 2011-10
      $2
    elsif season =~ /^(\d{4})[\-\/](\d{2})$/
      ## note: assume second year is always +1
      ##    todo/fix: add assert/check - why? why not?
      ## eg. 1999-00 => 2000 or 1899-00 => 1900
      ($1.to_i+1).to_s
    elsif season =~ /^(\d{4})$/
      $1
    else
      puts "*** !!!! wrong season format >>#{season}<<; exit; sorry"
      exit 1
    end
  end
end  # module SeasonHelper


module SeasonUtils
  extend SeasonHelper
  ##  lets you use SeasonHelper as "globals" eg.
  ##     SeasonUtils.prev( season ) etc.
end # SeasonUtils
