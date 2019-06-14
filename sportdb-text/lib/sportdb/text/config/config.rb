# encoding: utf-8

module SportDb
  module Import

def self.root
  File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__))))) )
end

def self.data_dir  ## rename to config_dir - why? why not?
  "#{root}/config"
end

def self.test_data_dir
  "#{root}/test/data"
end



class Configuration

  attr_accessor :team_mappings
  attr_accessor :teams

  attr_accessor :leagues



  def initialize

    ## unify team names; team (builtin/known/shared) name mappings
    ## cleanup team names - use local ("native") name with umlaut etc.
    recs = []
    %w(de fr mc es it pt nl be tr gr eng wal sco nir at al bg by ch cy cz dk fi ga hr hu ie is lu md mt no pl ro rs ru se si sk ua mx us ca).each do |country|
       recs += TeamReader.from_file( "#{Import.data_dir}/teams/#{country}.txt" )
    end

    ############################
    ## add team mappings
    ##   alt names to canonical pretty (recommended unique) name
    @team_mappings = {}

    recs.each do |rec|
       rec.alt_names.each do |alt_name|
         ## todo/fix: warn about duplicates (if key exits) ???????
         @team_mappings[ alt_name ] = rec.name
       end
    end

###
## reverse hash for lookup/list of "official / registered(?)"
##    pretty recommended canonical unique (long form)
##    team names


##
##  todo/fix: move to new TeamConfig class (for reuse) !!!!!!
    @teams = {}
    recs.each do |rec|
      @teams[ rec.name ] = rec
    end


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
