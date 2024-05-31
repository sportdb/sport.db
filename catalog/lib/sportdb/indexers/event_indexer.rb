module CatalogDb

class EventIndexer < Indexer
    def self.read( path )
      pack = SportDb::Package.new( path )   ## lets us use direcotry or zip archive

      recs = []
      pack.each_seasons do |entry|
        recs += SportDb::Import::EventInfoReader.parse( entry.read )
      end
      recs

      add( recs )
    end
 
 
    def add( rec_or_recs )  
      recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]   ## wrap (single) rec in array
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
