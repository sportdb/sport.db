##
#  see https://tzinfo.github.io/

require 'tzinfo'


identifiers = TZInfo::Timezone.all_identifiers
pp identifiers
puts "   #{identifiers.size} identifier(s)"
#=> 597 identifier(s)


codes = TZInfo::Country.all_codes
pp codes
puts "   #{codes.size} country code(s)"


codes.each do |code|
    c = TZInfo::Country.get( code )
    puts "==> #{code} - #{c.name}"
    pp c.zone_identifiers
end


def dump( tz )
  puts
  pp tz
  pp tz.canonical_zone
  pp tz.abbreviation
  pp tz.base_utc_offset
  pp tz.current_period
end

## try some
tz = TZInfo::Timezone.get('America/New_York')
dump( tz )

tz = TZInfo::Timezone.get('America/Argentina/Buenos_Aires')
dump( tz )

tz = TZInfo::Timezone.get('America/Sao_Paulo')
dump( tz )

tz = TZInfo::Timezone.get('America/Mexico_City')
dump( tz )

tz = TZInfo::Timezone.get('Europe/Vienna')
dump( tz )



puts "bye"