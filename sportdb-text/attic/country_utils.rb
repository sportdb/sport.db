# encoding: utf-8


module CountryHelper ## use Helpers why? why not?

  def key( basename )
    if basename =~ /^([a-z]{2,3})-/    ## check for leading country code (e.g. sco-scotland)
      $1   ## return code as string e.g. "sco"
    else
      puts "sorry unknown country - cannot auto-map from >#{basename}< - add to CountryHelper to fix"
      exit 1
    end
  end
  def code( basename ) key( basename ); end  ## alias for key (country_key==country_code) - why? why not?

end  # module CountryHelper


module CountryUtils
  extend CountryHelper
  ##  lets you use CountryHelper as "globals" eg.
  ##     CountryUtils.key( basename ) etc.
end # CountryUtils
