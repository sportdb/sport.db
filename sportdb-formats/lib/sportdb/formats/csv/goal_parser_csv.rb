
module SportDb
  class CsvGoalParser


  def self.read( path )
     txt = File.open( path, 'r:utf-8' ) {|f| f.read }   ## note: make sure to use (assume) utf-8
     parse( txt )
  end

  def self.parse( txt )
     new( txt ).parse
  end


  def initialize( txt )
    @txt = txt
  end

  def parse
    rows = parse_csv( @txt )
    recs = rows.map { |row| Sports::GoalEvent.build( row ) }
    ## pp recs[0]
    recs
  end

  end # class CsvGoalParser
end # module Sports
