####
### check - nest CET class inside UTC e.g. UTC::CET - why? why not?
##     make UTC and CET into a module (not class) - why? why not?

module CET   ## central european time helpers
  def self.now()  zone.now; end
  def self.today() now.to_date; end
  def self.strptime( str, format )

    ### fix - change to Time.strptime - why? why not?
    ##       (simply) ignore offset; double check that hours, minutes
    ##        get parsed as is (without applying offset)

    d = DateTime.strptime( str, format )
      ## remove assert check - why? why not?
      if d.zone != '+00:00'    ### use d.offset != Ration(0,1)  - why? why not?
        puts "!! ASSERT - CET parse date; DateTime returns offset != +0:00"
        pp d.zone
        pp d
        exit 1
     end

  ###  2006-03-26 02:00:00
  ##  raise exception
  ##    is an invalid local time. (TZInfo::PeriodNotFound)
    ## quick fix add +1
  ##  2012-03-25 02:00:00
  ##   is an invalid local time. (TZInfo::PeriodNotFound)

     if ['2018-03-25 02:00',
         '2012-03-25 02:00',
         '2006-03-26 02:00',
        ].include?( d.strftime( '%Y-%m-%d %H:%M' ))
       puts "!! hack - fix CET date #{d} - add +1 hour"
       pp d
       zone.local_time( d.year, d.month, d.day, d.hour+1, d.min, d.sec )
     else
       zone.local_time( d.year, d.month, d.day, d.hour, d.min, d.sec )
     end
  end
  def self.zone() @zone ||= UTC.find_zone( 'Europe/Vienna' ); end
end  # class CET



module UTC
  def self.now()  Time.now.utc; end
  def self.today() now.to_date; end

  ## -- todo - make sure / assert it's always utc - how???
  ## utc   = ## tz_utc.strptime( m['utcDate'], '%Y-%m-%dT%H:%M:%SZ' )
  ##  note:  DateTime.strptime  is supposed to be unaware of timezones!!!
  ##            use to parse utc
  ## quick hack -
  ##     use to_time.getutc instead of utc ???
  def self.strptime( str, format )
      d = DateTime.strptime( str, format )
      ## remove assert check - why? why not?
      if d.zone != '+00:00'    ### use d.offset != Ration(0,1)  - why? why not?
         puts "!! ASSERT - UTC parse date; DateTime returns offset != +0:00"
         pp d.zone
         pp d
         exit 1
      end
      ## note - ignores offset if any !!!!
      ##    todo/check - report warn if offset different from 0:00 (0/1) - why? why not?
      Time.utc( d.year, d.month, d.day, d.hour, d.min, d.sec )
  end

  def self.find_zone( name )
     zone = TZInfo::Timezone.get( name )
     ## wrap tzinfo timezone in our own - for adding more (auto)checks etc.
     zone ? Timezone.new( zone ) : nil
  end

class Timezone   ## nested inside UTC
   ## todo/fix
   ##  cache timezone - why? why not?
   def initialize( zone )
     @zone = zone
   end

   def name() @zone.name; end
   def dst?() @zone.dst?; end


   def to_local( time )
      ## assert time is Time (not Date or DateTIme)
      ##  and assert utc!!!
      assert( time.is_a?( Time ),  "time #{time} is NOT of class Time; got #{time.class.name}" )
      assert( time.utc?,           "time #{time} is NOT utc; utc? returns #{time.utc?}" )
      local = @zone.to_local( time )
      local
   end

   def local_time( year, month=1, mday=1, hour=0, min=0, sec=0 )
    ## add auto-fix for ambigious time (dst vs non-dst)
    ##    always select first for now (that is, dst)
      @zone.local_time( year, month, mday, hour, min, sec ) {|time| time.first }
   end

   def now() @zone.now; end




   def assert( cond, msg )
    if cond
      # do nothing
    else
      puts "!!! assert failed - #{msg}"
      exit 1
    end
  end
end  # class Timezone
end   # module UTC




module TimezoneHelper

def find_zone!( league:, season: )
  zone = find_zone( league: league, season: season )
  if zone.nil?  ## still not found; report error
    puts "!! ERROR: no timezone found for #{league} #{season}"
    exit 1
  end
  zone
end

def find_zone( league:, season: )
   ## note: do NOT pass in league struct! pass in key (string)
   raise ArgumentError, "league code as string|symbol expected"  unless league.is_a?(String) || league.is_a?(Symbol)

   @zones ||= begin
                zones = {}
                ['timezones_africa',
                 'timezones_america',
                 'timezones_asia',
                 'timezones_europe',
                 'timezones_middle_east',
                 'timezones_pacific',
                 'timezones_world',].each do |name|
                     recs = read_csv( "#{SportDb::Module::Timezones.root}/config/#{name}.csv" )
                     recs.each do |rec|
                        zone = UTC.find_zone( rec['zone'] )
                        if zone.nil?
                          ## raise ArgumentError - invalid zone
                          puts "!! ERROR - cannot find timezone in timezone db:"
                          pp rec
                          exit 1
                        end
                        zones[ rec['key']] = zone
                     end
                 end
                 zones
              end

   ## lookup first try by league+season
   league_code = league.to_s.downcase
   season      = Season( season )

   ##  e.g. world+2022, etc.
   key = "#{league_code}+#{season}"
   zone = @zones[key]

   ## try league e.g. eng.1 etc.
   zone = @zones[league_code]  if zone.nil?

   ## try first code only (country code )
   if zone.nil?
     code, _  = league_code.split( '.', 2 )
     zone = @zones[code]
   end

   zone
end
end #  module TimezoneHelper

