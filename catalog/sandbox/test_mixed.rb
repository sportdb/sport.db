

mixed = [
  'Nemzeti Bajnokság II',
  'NB II',
  'Ungarn NB II',
  'hun.2',
  'hun 2',
  'HUN 2',
]


names = []
codes = []

## only allow asci a to z (why? why not?)
##  excludes Ö1 or such (what else?)
IS_CODE_N_NAME_RE = %r{^
                           [\p{Lu}0-9. ]+
                       $}x
## add space (or /) - why? why not?
IS_CODE_RE           = %r{^
                            [\p{Ll}0-9.]+
                        $}x


mixed.each do |name|
   if IS_CODE_N_NAME_RE.match?( name )
      names << name
      codes << name
   elsif IS_CODE_RE.match?( name )
      codes << name
   else
      ## assume name
      names << name
   end
end


puts "names:"
pp names
puts "codes:"
pp codes

puts "bye"