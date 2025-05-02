###
##  to run use:
##    $ ruby sandbox/test_uefa_more.rb



$LOAD_PATH.unshift( './lib' )
require 'leagues'


require 'fifa'


uefa = Uefa.countries


season = '2023/24'

###
# try 2nd level and cups for uefa countries

uefa.each do |country|
   key = country.key
   ## use cup for liechtenstein (li)
   league_codes =   if key == 'li' 
                          ["li.cup"] 
                    else
                       ["#{key}.1", "#{key}.2", "#{key}.cup" ]
                    end

   league_codes.each do |league_code|                 
      league_info = LeagueCodes.find_by( code: league_code, season: season )
      if league_info.nil?
         puts "!!    #{league_code}"
      else
         puts "  OK  #{league_code}"
      end
   end
end


puts "bye"

