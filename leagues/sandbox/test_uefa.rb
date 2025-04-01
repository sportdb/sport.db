###
##  to run use:
##    $ ruby sandbox/test_uefa.rb


#
# todo/fix:
#   check timezones e.g
#   !! ERROR: no timezone found for kz.1 2023
#    ...


$LOAD_PATH.unshift( './lib' )
require 'leagues'


require 'fifa'


uefa = Uefa.countries


season = '2024/25'

codes = TZInfo::Country.all_codes


uefa.each do |country|
   key = country.key
   ## use cup for liechtenstein (li)
   league_code =  key == 'li' ? "#{key}.cup" : "#{key}.1"

   zone = find_zone( league: league_code, season: season )

   if zone.nil?
      puts "!! #{country.key} #{country.name} - no zone found"
      if codes.include?( key.upcase )
        c = TZInfo::Country.get( key.upcase )
        if c
          puts "#{c.name}:"
          pp c.zone_identifiers
        end
      end
   else
      puts "  OK #{country.key} #{country.name}   =>  #{zone.name}  -- #{zone.now} (dst? #{zone.dst?})"
      # pp zone
   end
end


puts "bye"

