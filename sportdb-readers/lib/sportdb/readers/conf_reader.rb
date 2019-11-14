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

    ## pass 2 - check & map; replace inline (string with record)
    recs.each do |rec|
      league = rec[:league]
      clubs = []    ## convert lines to clubs
      rec[:lines].each do |line|

        next if line =~ /^[ -]+$/   ## skip decorative lines with dash only (e.g. ---- or - - - -) etc.

        scan = StringScanner.new( line )

        if scan.check( /\d{1,2}[ ]+/ )    ## entry with standaning starts with ranking e.g. 1,2,3, etc.
          puts "  table entry >#{line}<"
          rank = scan.scan( /\d{1,2}[ ]+/ ).strip   # note: strip trailing spaces

          ## note: uses look ahead scan until we hit at least two spaces
          ##  or the end of string  (standing records for now optional)
          name = scan.scan_until( /(?=\s{2})|$/ )
          if scan.eos?
            standing = nil
          else
            standing = scan.rest.strip   # note: strip leading and trailing spaces
          end
          puts "   rank: >#{rank}<, name: >#{name}<, standing: >#{standing}<"

          ## note: rank and standing gets ignored (not used) for now
        else
          ## assume club is full line
          name = line
        end

        clubs << config.clubs.find_by( name: name, country: league.country )
      end

      rec[:clubs] = clubs
      rec.delete( :lines )   ## remove lines entry
    end

    ## pass 3 - import (insert/update) into db
    recs.each do |rec|
       league = Sync::League.find_or_create( rec[:league] )
       season = Sync::Season.find_or_create( rec[:season] )


       event  = Sync::Event.find_or_create( league: league, season: season )
       if rec[:stage]
         stage = Sync::Stage.find_or_create( rec[:stage], event: event )
       else
         stage = nil
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
