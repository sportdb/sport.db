# encoding: utf-8


module SeasonHelper ## use Helpers why? why not?

  ## note:
  ##   see more and "basic" season helpers
  ##     in the sportdb-config/boot library/gem

  def pretty_print( seasons )
    ## e.g. ['2015-16', '2014-15', '2013-14', '1999-00', '1998-99', '1993-94']
    ##      => (old) 2015-16..2013-14 (3) 1999-00..1998-99 (2) 1993-94
    ##      => (new) 2016...2013 (3) 2000..1998 (2) 1993-94   - why? why not?
    ##  or
    ##      ['2014-15', '1994-95']
    ##      => 2014-15 1994-95
    ##  or
    ##      ['2017-18', '2016-17', '2015-16', '2014-15', '2013-14', '2012-13', '2011-12', '2010-11', '2009-10', '2008-09', '2006-07', '2005-06', '2004-05', '2003-04']
    ##      => 2018......2008 (10) 2006-07..2003-04 (4)

    ## first sort by latest (newest) first
    seasons = seasons.sort.reverse

    ## step 1: collect seasons in runs
    runs = []
    seasons.each do |season|

      run = runs[-1]  ## get last run (note: returns nil if empty)

      if run.nil?
        ## start new run - very first season / item
        run = []
        run << season
        runs << run
      else
        season_prev = run[-1]  ## get last season from run
        year_prev   = season_prev[0..3].to_i  ## get year

        year = season[0..3].to_i  ## get year (from season) eg. 2015-16 => 2015

        if year == year_prev-1   ## keep adding to run
          run << season
        else ## start new run
          run = []
          run << season
          runs << run
        end
      end
    end

    ## step 2: print runs into buffer (string)
    buf = ''
    runs.each do |run|
       if run.size == 1
          buf << "#{run[0]} "
       else
          ## use first and last season
          ##  try for now use .. (2)
          ##                  ... (3)
          ##                  ..... (4) etc.

          ## was: buf << run[0]
          ##  for 2017-18  print => 2018

          buf << end_year( run[0] )
          buf << ('.' * run.size)
          buf << start_year( run[-1] )
          buf << " (#{run.size}) "
       end
    end
    buf = buf.strip   # remove trainling space(s)
    buf
  end


  def pretty_print_levels( levels )   ## todo: rename to levels_up_down or levels_line or something? why? why not?
    seasons = {}  ## seasons lookup with levels
    ups   = 0
    downs = 0

    level_keys = levels.keys
    level_keys.each do |level_key|
      level = levels[level_key]
      level.seasons.each do |season|
        seasons[season] ||= []
        seasons[season] << level_key   ## todo: check if level already included? possible? why? why not?
      end
    end

    buf = ''
    last_season = nil
    last_level  = nil

    seasons.keys.sort.reverse.each do |season|
       l = seasons[season]
       if l.size > 1
         buf << "**WARN: more than one level in season #{season}: #{l.join( )}** "
       else
         lfst = l[0]
         if last_season && last_level

           ## check for season == last_season-1 or season+1 == last_season (check for proper sequence/no missing season?)
           season_exp = prev( last_season )
           if season != season_exp
              buf << " **?? #{season_exp} ??** "   ## missing season/broken run
              ## todo/fix: check/output missing more than one season in run
           end

           ## check diff
           diff = last_level - lfst.to_i
           if diff > 0
             downs += 1
             buf << "⇓"
           elsif diff < 0
             ups += 1
             buf << "⇑"
           else
             # assume diff==0; do (add) nothing
           end
         end
         buf << "#{lfst} "

         last_season = season
         last_level  = lfst.to_i   ## always use/assume int
       end
    end

   ## e.g. ⇑ (2) / ⇓ (1):  1 ⇑2 2 ⇓1 1 ⇑2 2 2 2
    buf_header = ''
    buf_header << "⇑ (#{ups})"   if ups > 0
    if downs > 0
      buf_header << " / "     if ups > 0
      buf_header << "⇓ (#{downs})"
    end
    buf_header << ": "        if ups > 0 || downs > 0


    buf_header + buf
  end

end  # module SeasonHelper
