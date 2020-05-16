# encoding: utf-8


module SportDb

class PlayerStatReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models

## value helpers e.g. is_year?, is_taglist? etc.
##  include TextUtils::ValueHelper

##  include FixtureHelpers


  attr_reader :include_path


  def initialize( include_path, opts = {} )
    @include_path = include_path
  end


  def read( name, more_attribs={} )
    ## note:
    #    event_id and team_id required!!

    ## todo: move name_real_path code to LineReaderV2 ????
    pos = name.index( '!/')
    if pos.nil?
      name_real_path = name   # not found; real path is the same as name
    else
      # cut off everything until !/ e.g.
      #   at-austria!/w-wien/beers becomes
      #   w-wien/beers
      name_real_path = name[ (pos+2)..-1 ]
    end

    path = "#{include_path}/#{name_real_path}.csv"

    logger.info "parsing data '#{name}' (#{path})..."

    # event
    @event = Event.find( more_attribs[:event_id] )
    pp @event

    ## note: use @team - share/use in worker method
    @team = Team.find( more_attribs[:team_id] )
    pp @team

    read_csv_worker( path )
  end


  def read_csv_worker( path )
    
    csv = CSV.read( path, headers: true )

    ## todo:
    ##  for debug dump headers

    csv.each_with_index do |row,i|

      logger.debug "  [#{i}] " + row.inspect

      ##  person = Person.find_by_key( person_key )
      ## if person.nil?
      ##   logger.error " !!!!!! no mapping found for player in line >#{line}< for team #{@team.code} - #{@team.title}"
      ##    next   ## skip further processing of line; can NOT save w/o person; continue w/ next record
      ##  end
    end
  end # method read_csv_worker


end # class PlayerStatReader
end # module SportDb
