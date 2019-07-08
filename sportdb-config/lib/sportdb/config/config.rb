# encoding: utf-8

module SportDb
  module Import


class Configuration

  def initialize
    @errors = []     ## make parsing errors "global" for now
  end


  def team_mappings
    read_teams()        if @team_mappings.nil?
    @team_mappings
  end

  def teams
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
  attr_accessor   :errors

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

=begin
  CLUBS_DATAFILES = {   ## path by country to clubs.txt
      de:  'europe/de-deutschland',
      fr:  'europe/fr-france',
      mc:  'europe/mc-monaco',
      es:  'europe/es-espana',
      it:  'europe/it-italy',
      pt:  'europe/pt-portugal',
      nl:  'europe/nl-netherlands',
      be:  'europe/be-belgium',
      tr:  'europe/tr-turkey',
      gr:  'europe/gr-greece',
      eng: 'europe/eng-england',
      wal: 'europe/wal-wales',
      sco: 'europe/sco-scotland',
      nir: 'europe/nir-northern-ireland',
      at:  'europe/at-austria',
      al:  'europe/al-albania',
      bg:  'europe/bg-bulgaria',
      by:  'europe/by-belarus',
      ch:  'europe/ch-confoederatio-helvetica',
      cy:  'europe/cy-cyprus',
      cz:  'europe/cz-czech-republic',
      dk:  'europe/dk-denmark',
      fi:  'europe/fi-finland',
      ge:  'europe/ge-georgia',
      hr:  'europe/hr-croatia',
      hu:  'europe/hu-hungary',
      ie:  'europe/ie-ireland',
      is:  'europe/is-iceland',
      lu:  'europe/lu-luxembourg',
      md:  'europe/md-moldova',
      mt:  'europe/mt-malta',
      no:  'europe/no-norway',
      pl:  'europe/pl-poland',
      ro:  'europe/ro-romania',
      rs:  'europe/rs-serbia',
      ru:  'europe/ru-russia',
      se:  'europe/se-sweden',
      si:  'europe/si-slovenia',
      sk:  'europe/sk-slovakia',
      ua:  'europe/ua-ukraine',
      mx:  'north-america/mx-mexico',
      us:  'north-america/us-united-states',
      ca:  'north-america/ca-canada',
      ar:  'south-america/ar-argentina',
      br:  'south-america/br-brazil',
      jp:  'asia/jp-japan',
      cn:  'asia/cn-china' }
=end


  def read_teams
    ## unify team names; team (builtin/known/shared) name mappings
    ## cleanup team names - use local ("native") name with umlaut etc.
    recs = []
    @errors = []    ## reset errors

    ## todo/fix: pass along / use country code too
    datafiles = find_clubs_datafiles( clubs_dir )
    datafiles.each do |datafile|
       country  = datafile[0]    ## country code e.g. eng, at, de, etc.
       path     = datafile[1]
       recs += TeamReader.read( path )
    end

    ############################
    ## add team mappings
    ##   alt names to canonical pretty (recommended unique) name
    @team_mappings = {}

    recs.each do |rec|
       rec.alt_names.each do |alt_name|
         name = @team_mappings[ alt_name ]
         if name  ## todo/fix: add better warn about duplicates (if key exits) ???????
            msg = "** !!! WARN !!! - alt name conflict/duplicate - >#{alt_name}< will overwrite >#{name}< with >#{rec.name}<"
            puts msg
            @errors << msg
         else
           @team_mappings[ alt_name ] = rec.name
         end
       end
    end

###
## reverse hash for lookup/list of "official / registered(?)"
##    pretty recommended canonical unique (long form)
##    team names


##
##  todo/fix: move to new TeamConfig class (for reuse) !!!!!!
##   todo/fix:  add check for duplicates/conflicts too!!!
    @teams = {}
    recs.each do |rec|
      @teams[ rec.name ] = rec
    end

    if @errors.size > 0
      puts ""
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts " #{@errors.size} errors:"
      pp @errors
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
