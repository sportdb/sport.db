# encoding: utf-8

module SportDb


class ConfReaderV2    ## todo/check: rename to EventsReaderV2 (use plural?) why? why not?

  def self.config() Import.config; end    ## shortcut convenience helper


  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt, season: season )
  end

  def self.parse( txt, season: nil )
    recs = LeagueOutlineReader.parse( txt, season: season )
    pp recs

    ## pass 1 - check & map; replace inline (string with record)
    recs.each do |rec|

      club_conf = ConfParser.parse( rec[:lines] )

      league = rec[:league]
      clubs = []    ## convert lines to clubs

      club_conf.each do |club_name,_|
        ## note: rank and standing gets ignored (not used) for now

        clubs << config.clubs.find_by!( name: club_name,
                                        country: league.country )
      end

      rec[:clubs] = clubs

      rec.delete( :lines )   ## remove lines entry
    end

    ## pass 2 - import (insert/update) into db
    recs.each do |rec|
       league = Sync::League.find_or_create( rec[:league] )
       season = Sync::Season.find_or_create( rec[:season] )


       event  = Sync::Event.find_or_create( league: league, season: season )
       stage  = if rec[:stage]
                  Sync::Stage.find_or_create( rec[:stage], event: event )
                else
                  nil
                end


       rec[:clubs].each do |club_rec|
         club = Sync::Club.find_or_create( club_rec )
         ## add teams to event
         ##   todo/fix: check if team is alreay included?
         ##    or clear/destroy_all first!!!
         if stage
           stage.teams << club
         else
           event.teams << club
         end
       end
    end

    recs
  end # method read

end # class ConfReaderV2
end # module SportDb
