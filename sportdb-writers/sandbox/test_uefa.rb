###
##  to run use:
##    $ ruby sandbox/test_uefa.rb

$LOAD_PATH.unshift( '../../../sportdb/sport.db/parser/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/quick/lib' )
$LOAD_PATH.unshift( './lib' )
require 'sportdb/writers'



require 'fifa'


uefa = Uefa.countries


season = '2024/25'


uefa.each do |country|
   key = country.key
   ## use cup for liechtenstein (li)
   league_code =  key == 'li' ? "#{key}.cup" : "#{key}.1"

   league_info = Writer::LEAGUES[ league_code ]

   if league_info.nil?
      puts "!! #{country.key} #{country.name} - no league info found"
   else

      repo = Fbup::GitHubSync::REPOS[ league_code ]
      if repo.nil?
         puts "!! #{country.key} #{country.name} - no repo (info) found"
      else
        puts "  OK #{country.key} #{country.name}"
      end
      ## pp league_info
   end
end


puts "bye"

