# encoding: utf-8


class CsvMatchConverter

def self.convert( in_path, out_path )
  puts ''
  puts "convert >>#{in_path}<< to >>#{out_path}<<"


   ## use new CsvMatchReader
   matches = CsvMatchReader.read( in_path )

  ### todo/fix: check headers - how?
  ##  if present HomeTeam or HT required etc.
  ##   issue error/warn is not present
  ##
  ## puts "*** !!! wrong (unknown) headers format; cannot continue; fix it; sorry"
  ##    exit 1
  ##

  CsvMatchWriter.write( out_path, matches )
end

end # class CsvMatchConverter
