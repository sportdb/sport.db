# encoding: utf-8

module SportDb

class MatchLinter

  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    puts "reading match datafile >#{path}<..."
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt, season: season )
  end

  def self.parse( txt, season: nil )
    recs = LeagueOutlineReader.parse( txt, season: season )

    if recs.empty?    ## todo - check for filter - why? why not?
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
    recs
  end # method read
end # class MatchLinter
end # module SportDb
