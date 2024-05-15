

module CatalogDb
class Indexer     ## base indexer for shared common code

  ## helpers from club - use a helper module for includes - why? why not?
  include SportDb::NameHelper
  ## incl. strip_year( name )
  ##       has_year?( name)
  ##       strip_lang( name )
  ##       normalize( name )



  ## helper to always convert (possible) country key to existing country record
  ##  todo: make private - why? why not?
  def country( country )
    if country.is_a?( String ) || country.is_a?( Symbol )       
        puts "** !!! ERROR !!! - struct expect for now for country >#{country}<; sorry"
        exit 1
    end

    ## (re)use country struct - no need to run lookup again
    rec = Model::Country.find_by!( key: country.key )   
    rec
 end


end # class Indexer
end # module CatalogDb   