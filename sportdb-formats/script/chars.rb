#############
#  check unicode chars

## libs / gems
require 'unicode/name'



def print_chars( str )
  str.each_char do |ch|
    next  if ch == ' '   # skip space
    puts "  #{ch}  #{'U+%04X' % ch.ord} (#{ch.ord}) - #{Unicode::Name.of(ch)}"
  end
end


# -   Myllykosken Pallo −47, Finland  ### todo/fix: norm dash (− => -) !!!
# -   Saint Patrick’s Athletic FC, Ireland =>  ’ => '


norm = ". '’ º/ () _−-"

puts "norm:"
print_chars( norm )

=begin
  .  U+002E (46) - FULL STOP

  '  U+0027 (39) - APOSTROPHE
  ’  U+2019 (8217) - RIGHT SINGLE QUOTATION MARK

  º  U+00BA (186) - MASCULINE ORDINAL INDICATOR
  /  U+002F (47) - SOLIDUS
  (  U+0028 (40) - LEFT PARENTHESIS
  )  U+0029 (41) - RIGHT PARENTHESIS

  −  U+2212 (8722) - MINUS SIGN
  -  U+002D (45) - HYPHEN-MINUS
=end



###
## todo/fix: check what is the prefered (canoncical) modern way/character?
##    a) with cedilla     - şţ
##    b) with comma below - șț


romanian = "şș ţț"

puts "romanian:"
print_chars( romanian )

=begin
  ş  U+015F (351) - LATIN SMALL LETTER S WITH CEDILLA
  ș  U+0219 (537) - LATIN SMALL LETTER S WITH COMMA BELOW

  ţ  U+0163 (355) - LATIN SMALL LETTER T WITH CEDILLA
  ț  U+021B (539) - LATIN SMALL LETTER T WITH COMMA BELOW
=end