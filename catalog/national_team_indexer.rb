
module CatalogDb

  
class NationalTeamIndexer < Indexer

  def initialize( recs )
    add( recs )
  end

  
  def add( recs )
    ###########################################
    ## auto-fill national teams
    ## pp recs
    recs.each do |rec|

     team = Model::NationalTeam.create!(
                    key:  rec.key,
                    name: rec.name,
                    code: rec.code, 
                    ## alt_names:  - fix!!!! 
                    country_key:  country( rec.country ).key,   
               )
      pp team             
 
  
      ##  add all names (canonical name + alt names
      names = [rec.name] + rec.alt_names
      more_names = []
      ## check "hand-typed" names for year (auto-add)
      ## check for year(s) e.g. (1887-1911), (-2013),
      ##                        (1946-2001,2013-) etc.
      names.each do |name|
        if has_year?( name )
          more_names <<  strip_year( name )
        end
      end

      ## auto-add fifa code lookup
      more_names << rec.code.downcase 
   
      
      names += more_names
      ## check for duplicates - simple check for now - fix/improve
      ## todo/fix: (auto)remove duplicates - why? why not?
      count      = names.size
      count_uniq = names.uniq.size
      if count != count_uniq
        puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s) in national teams:"
        pp names
        pp rec
        exit 1
      end

      names.each do |name|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        name = strip_lang( name )
        norm = normalize( name )
        Model::NationalTeamName.create!( key:  team.key,
                                         name: norm )
      end
    end  ## each record
  end # method initialize

end   # class NationalTeamIndexer
end   # module CatalogDb

