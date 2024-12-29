

##
# use/find a better name
#    League Set, League Sheet,
#    Leagueset/LeagueSet, LeagueSheet/Leaguesheet  
#    or Leagues (only)??
#    or League Book, League Setup, ??
#    or Workset, Worksheet, Workbook, ...
#
#   move league config over here from sportdb-writers too!!!!!


#
#  note - Leagueset is for now top-level 
#              NOT in a namespace (e.g. Sports/SportDB) - keep - why? why not?


class Leagueset

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
    new(datasets)
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
    new(datasets)
end

def self.read( path ) parse( read_text( path )); end



def initialize( recs )
    @recs = recs
end

def size() @recs.size; end

def each( &blk )
    @recs.each do |league_key, seasons|
       blk.call( league_key, seasons )
    end
end


### use a function for (re)use
###   note - may add seasons in place!! (if seasons is empty)
def validate!( source_path: ['.'] )
    each do |league_key, seasons|
  
      league_info = find_league_info( league_key )
      if league_info.nil?
        puts "!! ERROR - no league (config) found for >#{league_key}<; sorry"
        exit 1
      end
  
  
      if seasons.empty?
        ## simple heuristic to find current season
        [ Season( '2024/25'), Season( '2024') ].each do |season|
           filename = "#{season.to_path}/#{league_key}.csv"
           path = find_file( filename, path: source_path )
           if path
              seasons << season
              break
           end
        end
  
        if seasons.empty?
          puts "!! ERROR - no latest auto-season via source found for #{league_key}; sorry"
          exit 1
        end
      end
  
      ## check source path too upfront - why? why not?
      seasons.each do |season|
           filename = "#{season.to_path}/#{league_key}.csv"
           path = find_file( filename, path: source_path )
  
           if path.nil?
             puts "!! ERROR - no source found for #{filename}; sorry"
             exit 1
           end
      end
   end # each record
end
  




def pretty_print( printer )
    printer.text( "<Leagueset: " )
    printer.text( @recs )
    printer.text( ">")
end

end  # module Leagueset

