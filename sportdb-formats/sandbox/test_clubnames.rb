#######
# test club names

## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../quick/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

## our own code
require 'sportdb/formats'



CLUB_NAME_RE = SportDb::QuickMatchLinter::CLUB_NAME_RE

names = [
    "SP Tre Fiori (SMR)",
    "Inter Club d'Escaldes (AND)",
    "Inter Club d'Escaldes (And)",
]

names.each do |name|
  m = CLUB_NAME_RE.match( name )
  pp m
end


puts "bye"