

##
# use/find a better name
#    League Set, League Sheet,
#    Leagueset/LeagueSet, LeagueSheet/Leaguesheet  
#    or Leagues (only)??
#    or League Book, League Setup, ??
#    or Workset, Worksheet, Workbook, ...
#
#   move league config over here from sportdb-writers too!!!!!


module Leagueset
def self.parse_args( args )
    ### split args in datasets with leagues and seasons
    datasets = []
    args.each do |arg|
       if arg =~ %r{^[0-9/-]+$}   ##  season
           if datasets.empty?
             puts "!! ERROR - league required before season arg; sorry"
             exit 1
           end

           season = Season.parse( arg )  ## check season
           datasets[-1][1] << season
       else ## assume league key
           key = arg.downcase
           datasets << [key, []]
       end
    end
    datasets
end


def self.parse( txt )
    ### split args in datasets with leagues and seasons
    datasets = []
    recs = parse_csv( txt )
    recs.each do |rec|
        key = rec['league'].downcase
        datasets << [key, []]

        seasons_str = rec['seasons']
        seasons = seasons_str.split( /[ ]+/ )

        seasons.each do |season_str|
            ## note - add support for ranges e.g. 2001/02..2010/11
            if season_str.index( '..' )
                    fst,snd = season_str.split( '..' )
                    # pp [fst,snd]
                    fst = Season.parse( fst )
                    snd = Season.parse( snd )
                    if fst < snd && fst.year? == snd.year?
                        datasets[-1][1] += (fst..snd).to_a
                    else
                       raise ArgumentError, "parse error - invalid season range >#{str}<, 1) two seasons required, 2) first < second, 3) same (year/academic) type"
                    end
            else
               season = Season.parse( season_str )  ## check season
               datasets[-1][1] << season
            end
        end
    end
    datasets
end


def self.read( path )
    parse( read_text( path ))
end
end  # module Leagueset

