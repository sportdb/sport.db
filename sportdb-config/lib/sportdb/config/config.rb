# encoding: utf-8

module SportDb
  module Import


class Configuration


  def team_mappings    ## todo/fix: rename to clubs_mappings - why? why not?
    read_teams()        if @team_mappings.nil?
    @team_mappings
  end

  def teams             ## todo/fix: rename to clubs - why? why not?
    read_teams()        if @teams.nil?
    @teams
  end

  def leagues
    read_leagues()      if @leagues.nil?
    @leagues
  end


  ####
  #  todo/fix:  find a better way to configure club / team datasets
  attr_accessor   :clubs_dir
  def clubs_dir()   @clubs_dir ||= './clubs'; end


  CLUBS_REGEX1 = %r{  (?:^|/)            # beginning (^) or beginning of path (/)
                       (?<country>[a-z]{1,3})\.clubs\.txt$
                   }x

  CLUBS_REGEX2 = %r{  (?:^|/)            # beginning (^) or beginning of path (/)
                       (?<country>[a-z]{2,3})-[^/]+?
                         /clubs\.txt$
                   }x

  CLUBS_REGEX = Regexp.union( CLUBS_REGEX1, CLUBS_REGEX2 )


  def find_clubs_datafiles( path )
     datafiles = []   ## note: [country, path] pairs for now

     ## check all txt files as candidates  (MUST include country code for now)
     candidates = Dir.glob( "#{path}/**/*.txt" )
     pp candidates
     candidates.each do |candidate|
       m = CLUBS_REGEX.match( candidate )
       if m
         datafiles << [m[:country], candidate]
       end
     end

     pp datafiles
     datafiles
  end


  class ClubsHash   ## todo/check: use (rename to) ClubsMapping(s) - why? why not?
    def initialize
      @h      = {}
      @errors = []
    end

    attr_reader :errors
    def errors?() @errors.empty? == false; end

    def add( rec )   ## add club record / alt_names
      rec.alt_names.each do |alt_name|
        alt_recs = @h[ alt_name ]
        if alt_recs
          msg = "** !!! WARN !!! - alt name conflict/duplicate - >#{alt_name}< will overwrite >#{alt_recs[0].name}, #{alt_recs[0].country.name}< with >#{rec.name}, #{rec.country.name}<"
          puts msg
          @errors << msg
          alt_recs << rec
        else
          @h[ alt_name ] = [rec]
        end
      end
    end

    def fetch( alt_name ) @h[alt_name]; end
    def []( alt_name )   ## quick fix: for now returns first name; use fetch for recs array for now!!!
       ## keep "compatible" with old code for now
       alt_recs = @h[ alt_name ]
       if alt_recs
         alt_recs[0].name   ## use canonical name of first match for now
       else
         nil   # nothing found
       end
    end
  end # class ClubHash


  def read_teams   ## todo/fix: rename to read_clubs - why? why not?
    ## unify team names; team (builtin/known/shared) name mappings
    ## cleanup team names - use local ("native") name with umlaut etc.
    recs = []

    ## todo/fix: pass along / use country code too
    ##   note: country code no longer needed in path (is now expected as heading inside the file)

    ## todo/fix: add to teamreader
    ##              check that name and alt_names for a club are all unique (not duplicates)
    datafiles = find_clubs_datafiles( clubs_dir )
    datafiles.each do |datafile|
       country  = datafile[0]    ## country code e.g. eng, at, de, etc.
       path     = datafile[1]
       recs += TeamReader.read( path )
    end

    ############################
    ## add team mappings
    ##   alt names to canonical pretty (recommended unique) name
    @team_mappings = ClubsHash.new
    recs.each { |rec| @team_mappings.add( rec ) }

###
## reverse hash for lookup/list of "official / registered(?)"
##    pretty recommended canonical unique (long form)
##    team names

    @teams = {}
    recs.each do |rec|
      old_rec = @teams[ rec.name ]
      if old_rec
        puts "** !!! ERROR !!! - (canonical) name conflict - duplicate - >#{rec.name}< will overwrite >#{old_rec.name}<:"
        pp old_rec
        pp rec
        exit 1
      else
        @teams[ rec.name ] = rec

        ## note: check if there's an alternative name registered
        ##           for the canonical name
        ##    todo/fix: find a better scheme for (alt) name mapping - why? why not?
        ##   allow alt names same as canonical names if not is the same club/record - why? why not?
        alt_recs =  @team_mappings.fetch( rec.name )
        if alt_recs
          puts "** !!! ERROR !!! - (canonical) name conflict - >#{rec.name}< registered already as alternative name mapping:"
          pp alt_recs

          ## note: exit now only if it's the same club (that has alt name that is the canonical name)
          exit 1    if alt_recs.include?(rec)
        end
      end
    end

    if @team_mappings.errors?
      puts ""
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts " #{@team_mappings.errors.size} errors:"
      pp @team_mappings.errors
      ## exit 1
    end

    self  ## return self for chaining
end



def read_leagues
    #####
    # add / read-in leagues config
    @leagues = LeagueConfig.new

    self  ## return self for chaining
  end
end # class Configuration





## lets you use
##   SportDb::Import.configure do |config|
##      config.hello = 'World'
##   end

def self.configure
  yield( config )
end

def self.config
  @config ||= Configuration.new
end

end   # module Import
end   # module SportDb
