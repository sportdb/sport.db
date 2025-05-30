
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
#
#   find a better way to handle league codes
#            always map to canoncial codes - why? why not?



module SportDb
class Leagueset


##  autofiller helper
##  - simple heuristic to find current (latest) season
##
##   maybe move autofiller to fbup or such - why? why not?

def self.autofiller( league_query, source_path: ['.'] )
      [ Season('2024/25'), 
        Season('2025') 
      ].each do |season|
           league_info = LeagueCodes.find_by( code: league_query, season: season )
           league_code = league_info['code']
           
           filename = "#{season.to_path}/#{league_code}.csv"
           path = find_file( filename, path: source_path )
           if path
              return season
           end
      end
      nil  ## return nil if not found
end




###
## note - requires autofill (for seasons)
##         if league querykey without season/empty season
def self.parse_args( args, autofill: nil )
    ### split args in datasets with leagues and seasons
    ##   e.g.  at1 eng1    or
    ##         at1 2024/25 br1 2025    etc.
    datasets = []
    args.each do |arg|
       if arg =~ %r{^[0-9/-]+$}   ##  season
           if datasets.empty?
             puts "!! ERROR [leagueset.parse_args] - league required before season arg; sorry"
             exit 1
           end

           season = Season.parse( arg )  ## check season
           datasets[-1][1] << season
       else ## assume league key
           key = arg.downcase
           datasets << [key, []]
       end
    end

    new(datasets, autofill: autofill)
end



def self.parse( txt, autofill: nil )
    ### split args in datasets with leagues and seasons
    datasets = []
    recs = parse_csv( txt )
    recs.each do |rec|
        key = rec['league'].downcase
  
        seasons_str = rec['seasons']
        seasons =  Season.parse_line( seasons_str )

        datasets << [key, seasons]
  end 

    new(datasets, autofill: autofill)
end

def self.read( path, autofill: nil ) 
   parse( read_text( path ), autofill: autofill )
end



def initialize( recs, autofill: nil )
    ### @org_recs = recs    ## keep a record of orginal (MUST clone) - why? why not?

    ##### check for empty seasons
    recs      = _autofill( recs, autofill: autofill )
    @recs     = _norm( recs )
end


def _norm( recs )
  datasets = {}
 
  recs.each do |league_query, seasons| 
    unless LeagueCodes.valid?( league_query ) 
      puts "!! ERROR - (leagueset) no league (config) found for code >#{league_query}<; sorry"
      exit 1
    end

    seasons.each do |season|
         ## check league code config too - why? why not?
         league_info = LeagueCodes.find_by( code: league_query, season: season )
         if league_info.nil?
           puts "!! ERROR - (leagueset) no league config found for code #{league_query} AND season #{season}; sorry"
           exit 1
         end
 
         rec = datasets[ league_info['code'] ] ||= []
         rec << season
    end
  end # each record

  datasets.to_a  ## convert hash to array
end

def _autofill( datasets, autofill: )
  ##### check for empty seasons
  datasets.each do |league_query, seasons|
    ### try autofill
    if seasons.empty? && autofill.is_a?(Proc)
         season = autofill.call( league_query )
         if season 
              ## note - all season as string for autfiller too
            seasons << Season(season)   
         end 
    end     
        
    if seasons.empty?
      puts "!! ERROR [leagueset] - empty seasons; autofill found no latest season for #{league_query}; sorry"
      exit 1
    end
  end
end




def size() @recs.size; end

def each( &blk )
    @recs.each do |league_key, seasons|
       blk.call( league_key, seasons )
    end
end






### use a function for (re)use
###   note - may add seasons in place!! (if seasons is empty)
##
##   todo/check - change source_path to (simply) path - why? why not?
##
##
##  add a flag for allowing empty/auto-fill of seasons - why? why not?
##     or make it a separate method e.g. complete/fix_seasons or such? - why? why not?


def validate!( source_path: ['.'] )
    each do |league_key, seasons|
  
      unless LeagueCodes.valid?( league_key ) 
        puts "!! ERROR - (leagueset) no league (config) found for code >#{league_key}<; sorry"
        exit 1
      end
  
      ## check source path too upfront - why? why not?
      seasons.each do |season|
           ## check league code config too - why? why not?
           league_info = LeagueCodes.find_by( code: league_key, season: season )
           if league_info.nil?
             puts "!! ERROR - (leagueset) no league config found for code #{league_key}  AND season #{season}; sorry"
             exit 1
           end
   
           filename = "#{season.to_path}/#{league_info['code']}.csv"
           path = find_file( filename, path: source_path )
  
           if path.nil?
             puts "!! ERROR - (leagueset) no source found for #{filename}; sorry"
             exit 1
           end
      end
   end # each record
end
  


## todo/check: find a better name for helper?
##   find_all_datasets, filter_datatsets - add alias(es???
##  queries (lik ARGV) e.g. ['at'] or ['eng', 'de'] etc. list of strings
##
##  todo/fix - check if used anywhere???
##            - check if works with new alt codes too (or needs update)???

def filter( queries=[] )
  ## find all matching leagues (that is, league keys)
  if queries.empty?  ## no filter - get all league keys
    self
  else
    recs = @recs.find_all do |league_key, seasons|
                               found = false
                              ## note: normalize league key 
                              ##        (remove dot and downcase)
                              norm_key = league_key.gsub( '.', '' )
                              queries.each do |query|
                                 q = query.gsub( '.', '' ).downcase
                                 if norm_key.start_with?( q )
                                   found = true
                                   break
                                 end
                              end
                              found
                           end
    ## return new typed leagueset
    self.class.new( recs )
  end
end


def pretty_print( printer )
    printer.text( "<Leagueset: " )
    printer.text( @recs )
    printer.text( ">")
end

end  # module Leagueset
end  # module SportDb

