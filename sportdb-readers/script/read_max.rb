##
#  use
#   $ ruby script/read_max.rb


require_relative 'boot'

File.delete( './max.db' )   if File.exist?( './max.db' )


SportDb.open( './max.db' )


## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)

=begin
   OK          austria              - 61 datafile(s)
   OK          deutschland          - 25 datafile(s)
   OK          england              - 132 datafile(s)
   OK          italy                - 15 datafile(s)
   OK          espana               - 15 datafile(s)
   OK          europe               - 108 datafile(s)
   OK          champions-league     - 5 datafile(s)
   OK          south-america        - 27 datafile(s)
   OK          mexico               - 12 datafile(s)
   OK          africa               - 8 datafile(s)
   OK          league-starter       - 6 datafile(s)
=end

names = [  'europe',
          # 'mexico',
          # 'italy',
          # 'champions-league',  -- check for N.N. (defaults now to N.N. (GER)!!!!)
          # 'south-america',
          # 'austria',
          # 'deutschland',
        ]

names.each_with_index do |name,i|
  path = "#{OPENFOOTBALL_PATH}/#{name}"

  pack = SportDb::Package.new( path )
  pack.read_match
end


puts "table stats:"
SportDb.tables


puts 'bye'

