# encoding: utf-8


module SeasonHelper ## use Helpers why? why not?

  ##############################################
  ### deprecated!!! use new Season class!!!
  ##   this code will get removed!!!!
  ###################################################

  def prev( str )   SportDb::Import::Season.new( str ).prev;  end
  def key( str )    SportDb::Import::Season.new( str ).key;   end
  def directory( str, format: nil )  SportDb::Import::Season.new( str ).directory( format: format );  end

  ## note: new start_year now returns an integer number (no longer a string)!!!
  def start_year( str )  SportDb::Import::Season.new( str ).start_year;  end
  ## note: new end_year now returns an integer number (no longer a string)!!!
  ##       if now end_year (year? == true) than returns nil (no longer the start_year "as fallback")!!!
  def end_year( str )   SportDb::Import::Season.new( str ).end_year;  end
end  # module SeasonHelper


module SeasonUtils
  extend SeasonHelper
  ##  lets you use SeasonHelper as "globals" eg.
  ##     SeasonUtils.prev( season ) etc.
end # SeasonUtils
