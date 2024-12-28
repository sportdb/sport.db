require 'season/formats'

###
##  parse season periods
##
##  2001/02..2015/16

##
## fix: move upstream to seasons!!!

def parse_seasons( str )
 if str.index( '..')
    fst,snd = str.split( '..' )
    pp [fst,snd]
    fst = Season.parse( fst )
    snd = Season.parse( snd )

    if fst < snd && fst.year? == snd.year?
        seasons = (fst..snd).to_a
        pp seasons
        seasons
    else
       raise ArgumentError, "parse error - invalid season range >#{str}<, 1) two seasons required, 2) first < second, 3) same (year/academic) type"
    end
  end
end




str = '2001/02..2015/16'
parse_seasons( str )

str = '2001/02'
parse_seasons( str )

str = '2001/02..2002/03'
parse_seasons( str )

# str = '2021/22..2015/16'
# parse_seasons( str )

# str = '2001/02..2015'
# parse_seasons( str )


puts "bye"