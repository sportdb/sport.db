require 'cocos'
require 'tzinfo'


recs = []
['timezones_africa',
 'timezones_america',
 'timezones_asia',
 'timezones_europe',
 'timezones_middle_east',
 'timezones_pacific',
 'timezones_world',].each do |name|
    recs += read_csv( "./config/#{name}.csv" )
end
pp recs


def dump( tz )
    puts
    pp tz
    pp tz.canonical_zone
    pp tz.abbreviation
    pp tz.base_utc_offset
    # pp tz.current_period
end


warns = []

recs.each do |rec|
    pp rec
    tz = TZInfo::Timezone.get( rec['zone'] )
    if tz.nil?
        puts "!! ERROR - no zone found for:"
        pp rec
        exit 1
    end
    dump( tz )

    unless tz.is_a?( TZInfo::DataTimezone )
        puts "!! WARN - not canonicial? (linked?)"

        ## try to use canonical only for now
        warns << "#{tz}  NOT canonicial - linked to #{tz.canonical_zone}"
    end
end


pp warns

puts "bye"



__END__


 "Europe - San Marino  NOT canonicial - linked to Europe - Rome",
 "Europe - Vatican  NOT canonicial - linked to Europe - Rome",
 "Europe - Monaco  NOT canonicial - linked to Europe - Paris",
 "Europe - Vaduz  NOT canonicial - linked to Europe - Zurich",
 "Europe - Bratislava  NOT canonicial - linked to Europe - Prague",
 "Europe - Ljubljana  NOT canonicial - linked to Europe - Belgrade",
 "Europe - Skopje  NOT canonicial - linked to Europe - Belgrade",
 "Europe - Luxembourg  NOT canonicial - linked to Europe - Brussels",
 "Europe - Amsterdam  NOT canonicial - linked to Europe - Brussels",
 "Iceland  NOT canonicial - linked to Africa - Abidjan",
 "Europe - Copenhagen  NOT canonicial - linked to Europe - Berlin",
 "Europe - Stockholm  NOT canonicial - linked to Europe - Berlin",
 "Europe - Oslo  NOT canonicial - linked to Europe - Berlin",
 "Europe - Zagreb  NOT canonicial - linked to Europe - Belgrade",
 "Europe - Sarajevo  NOT canonicial - linked to Europe - Belgrade",
 "Europe - Podgorica  NOT canonicial - linked to Europe - Belgrade"

