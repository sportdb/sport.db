#######
# test search (struct convenience) helpers/methods

## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-langs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))


## our own code
require 'sportdb/formats'


require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../catalog/catalog.db'


Country      = Sports::Country
League       = Sports::League
NationalTeam = Sports::NationalTeam
Club         = Sports::Club


txt = <<TXT

Group A  |    Germany   Scotland     Hungary   Switzerland
Group B  |  Spain     Croatia      Italy     Albania
Group C  |  Slovenia  Denmark      Serbia    England
Group D  |  Poland    Netherlands  Austria   France
Group E  |  Belgium   Slovakia     Romania   Ukraine
Group F  |  Turkey    Georgia      Portugal  Czech Republic


Matchday 1  |  Fri Jun/14 - Tue Jun/18
Matchday 2  |   Wed Jun/19 - Sat Jun/22
Matchday 3  |  Sun Jun/23 - Wed Jun/26


Group A
Fri Jun/14
 (1)  21:00   Germany   5-1 (3-0)  Scotland     @ München
                Wirtz 10' Musiala 19' Havertz 45+1' (pen.)  Füllkrug 68' Can 90+3';
                Rüdiger 87' (o.g.)
Sat Jun/15
 (2)  15.00    Hungary   1-3 (0-2)   Switzerland  @ Köln
                 Varga 66';
                 Duah 12' Aebischer 45' Embolo 90+3'


Semi-finals
Tu July/9 2024

(50)  21h00    Netherlands  1-2 (1-1)   England    @ Dortmund
                  Simons 7'; Kane 18' (pen.) Watkins 90+1'

Final
Sunday Jul 14 2024
(51)   21.00   Spain  -  England         @ Berlin

TXT

puts txt
puts


lines = txt
start = Date.new( 2024, 6, 1 )


SportDb::MatchParserV2.debug = true

parser = SportDb::MatchParserV2.new( lines, start )
pp parser

pp parser.parse

puts "bye"