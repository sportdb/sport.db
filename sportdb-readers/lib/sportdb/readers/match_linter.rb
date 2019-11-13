# encoding: utf-8

module SportDb

class MatchLinter

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    puts "reading match datafile >#{path}<..."
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    recs = LeagueOutlineReader.parse( txt )

    if recs.empty?
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
