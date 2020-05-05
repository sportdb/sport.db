# encoding: utf-8

module SportDb


class ConfReaderV2    ## todo/check: rename to EventsReaderV2 (use plural?) why? why not?

  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
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
    secs = LeagueOutlineReader.parse( @txt, season: season )
    pp secs

    ## pass 1 - check & map; replace inline (string with record)
    secs.each do |sec|    # sec(tion)s

      conf = ConfParser.parse( sec[:lines] )

      league = sec[:league]
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


      sec[:teams] = teams

      sec.delete( :lines )   ## remove lines entry
    end


    ## pass 2 - import (insert/update) into db
    secs.each do |sec|   # sec(tion)s
       ## todo/fix: always return Season struct record in LeagueReader - why? why not?
       event_rec  = Sync::Event.find_or_create_by( league: sec[:league],
                                                   season: sec[:season] )

       stage_rec  = if sec[:stage]
                      Sync::Stage.find_or_create( sec[:stage], event: event_rec )
                    else
                      nil
                    end

       ## todo/fix: check if all teams are unique
       ##   check if uniq works for club/national_team record (struct) - yes,no ??
       teams = sec[:teams]
       teams = teams.uniq

       ## add to database
       team_recs     =  stage_rec ? stage_rec.teams    : event_rec.teams
       team_ids      =  stage_rec ? stage_rec.team_ids : event_rec.team_ids

       new_team_recs = Sync::Team.find_or_create( teams )
       new_team_recs.each do |team_rec|
         ## add teams to event
         ##   for now check if team is alreay included
         ##   todo/fix: clear/destroy_all first - why? why not!!!
         team_recs << team_rec    unless team_ids.include?( team_rec.id )
       end
    end

    true   ## todo/fix: return true/false or something
  end # method read

  def catalog() Import.catalog; end  ## shortcut convenience helper

end # class ConfReaderV2
end # module SportDb
