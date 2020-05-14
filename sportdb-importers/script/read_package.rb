##
#  to run use:
#    ruby -I ./lib script/read_package.rb


require_relative 'boot'


LEAGUES = SportDb::Import.catalog.leagues


FOOTBALLCSV_PATH  = '../../../footballcsv'

# path = "#{FOOTBALLCSV_PATH}/europe-champions-league"
path = "#{FOOTBALLCSV_PATH}/england"
# path = "#{FOOTBALLCSV_PATH}/austria"

pack = SportDb::Package.new( path )

pack.match_by_season( format: 'csv' ).each do |season, entries|
  puts "season #{season} - #{entries.size} entries:"
  entries.each do |entry|
    basename = File.basename( entry.name, File.extname( entry.name ) )  ## get basename WITHOUT extension
    leagues = LEAGUES.match( basename )
    if leagues.nil? || leagues.empty?
      puts "!!  #{basename}"
    elsif leagues.size > 1
      puts "x#{leagues.size}  #{basename}"
    else
      league = leagues[0]
      print "    #{basename}  =>  #{league.name} (#{league.key})"
      print ", #{league.country.name} (#{league.country.key})"   if league.country
      print "\n"
    end
  end
end

=begin
season 1921/22 - 4 datafiles:
eng.1
eng.2
eng.3a
eng.3b
...

season 1957/58 - 4 datafiles:
    eng.1  =>  Premier League (eng.1), England (eng)
    eng.2  =>  Championship (eng.2), England (eng)
!!  eng.3a
!!  eng.3b

season 1891/92 - 1 datafiles:
    eng.1  =>  Premier League (eng.1), England (eng)
season 1892/93 - 2 datafiles:
    eng.1  =>  Premier League (eng.1), England (eng)
    eng.2  =>  Championship (eng.2), England (eng)
=end


puts "bye"
