####
#  add more experimental functionality to season class
#    e.g. parse season ranges e.g.  2020..2024
#         parse list of seasons incl. ranges  e.g.  2020/21 2021/22..2023/24

class Season


def self.parse_range( str )
    range = nil
    
    fst,snd = str.split( '..' )
    # pp [fst,snd]
    fst = parse( fst )
    snd = parse( snd )
    if fst < snd && fst.year? == snd.year?
        range = fst..snd
    else
       raise ArgumentError, "parse error - invalid season range >#{str}<, (1) two seasons required, (2) first < second, (3) same (year/academic) type"
     end
    range
end

# check - find a better name - why? why not?
##   e.g Season.parse_list or parse_lst
#                          or parse_multi(ple)?
def self.parse_line( str )   
    ## helper to parse seasons string/column
    ##   note: ALWAYS returns an array of seaons (even if only one)
    result  = []
    seasons = str.split( /[ ]+/ )
 
    seasons.each do |season_str|
        ## note - add support for ranges e.g. 2001/02..2010/11
        if season_str.index( '..' )
            ## note - "unfold" range into array (use to_a) 
           result += parse_range( season_str ).to_a
        else
           result << parse( season_str ) 
        end
    end
 
    result
end
 

end # class Season