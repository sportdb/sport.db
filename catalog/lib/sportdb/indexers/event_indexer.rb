module CatalogDb

class EventIndexer < Indexer
    def self.build( path )
      pack = SportDb::Package.new( path )   ## lets us use direcotry or zip archive

      recs = []
      pack.each_seasons do |entry|
        recs += SportDb::Import::EventInfoReader.parse( entry.read )
      end
      recs

      index = new
      index.add( recs )
      index
    end

 
    def add( recs )
      recs.each do |rec|
        ## pp rec
         info = Model::EventInfo.create!(
                          league_key: rec.league.key,
                          season:     rec.season.key,
                          teams:      rec.teams,
                          matches:    rec.matches,
                          goals:      rec.goals,
                          start_date: rec.start_date ? rec.start_date.strftime('%Y-%m-%d') : nil,
                          end_date:   rec.end_date   ? rec.end_date.strftime('%Y-%m-%d') : nil,
                       )
         pp info              
      end  
    end    
end  ## class EventIndexer
end  # module CatalogDb
