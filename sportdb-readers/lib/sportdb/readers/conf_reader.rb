# encoding: utf-8

module SportDb


class ConfReaderV2    ## todo/check: rename to EventsReaderV2 (use plural?) why? why not?

  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt, season: season )
  end

  def self.parse( txt, season: nil )
    new( txt ).parse( season: season )
  end


  include Logging

  def initialize( txt )
    @txt = txt
  end

  def parse( season: nil )
    recs = LeagueOutlineReader.parse( @txt, season: season )
    pp recs

    ## pass 1 - check & map; replace inline (string with record)
    recs.each do |rec|

      conf = ConfParser.parse( rec[:lines] )

      league = rec[:league]
      teams = []    ## convert lines to teams

      if league.clubs?
        if league.intl?
          conf.each do |name, rec|
            country_key = rec[:country]
            teams << catalog.clubs.find_by!( name: name,
                                            country: country_key )
          end
        else
          conf.each do |name, _|
            ## note: rank and standing gets ignored (not used) for now
            teams << catalog.clubs.find_by!( name: name,
                                            country: league.country )
          end
        end
      else   ### assume national teams
        conf.each do |name, _|
          ## note: rank and standing gets ignored (not used) for now
          teams << catalog.national_teams.find!( name )
        end
      end


      rec[:teams] = teams

      rec.delete( :lines )   ## remove lines entry
    end


    ## pass 2 - import (insert/update) into db
    recs.each do |rec|
       ## todo/fix: always return Season struct record in LeagueReader - why? why not?
       event  = Sync::Event.find_or_create_by( league: rec[:league],
                                               season: Import::Season.new(rec[:season]) )

       stage  = if rec[:stage]
                  Sync::Stage.find_or_create( rec[:stage], event: event )
                else
                  nil
                end

       ## todo/fix: check if all teams are unique
       ##   check if uniq works for club/national_team record (struct) - yes,no ??
       team_recs = rec[:teams]
       team_recs = team_recs.uniq

       ## add to database
       teams     =  stage ? stage.teams    : event.teams
       team_ids  =  stage ? stage.team_ids : event.team_ids

       team_recs.each do |team_rec|
         team = if team_rec.is_a?( Import::Club )  ## todo/fix: use team_rec.club? !!! - why? why not?
                   Sync::Club.find_or_create( team_rec )
                else  ### assume NationalTeam
                   Sync::NationalTeam.find_or_create( team_rec )
                end

         ## add teams to event
         ##   for now check if team is alreay included
         ##   todo/fix: clear/destroy_all first - why? why not!!!
         teams << team    unless team_ids.include?( team.id )
       end
    end

    recs   ## todo/fix: return true/false or something -  recs isn't really working/meaninful - why? why not?
  end # method read

  def catalog() Import.catalog; end  ## shortcut convenience helper

end # class ConfReaderV2
end # module SportDb
