# encoding: utf-8

module SportDb


class ConfLinter

  def self.config() Import.config; end    ## shortcut convenience helper


  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    puts "reading conf(iguration) datafile >#{path}<..."
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt, season: season )
  end

  def self.parse( txt, season: nil )
    recs = LeagueOutlineReader.parse( txt, season: season )

    if recs.empty?     ## todo: check for season filter - why? why not?
      puts "  ** !!! WARN !!! - no league headings found"
    else
      puts "  found #{recs.size} league (+season+stage) headings"
      recs.each do |rec|
         ## rec[:league] )
         ## rec[:season] )
         ## rec[:stage]
         puts "   league: >#{rec[:league]}<, season: >#{rec[:season]}<, stage: >#{rec[:stage]}<"
      end
    end

    ## pass 2 - check & map; replace inline (string with record)
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

    recs
  end # method read

end # class ConfLinter

end # module SportDb
