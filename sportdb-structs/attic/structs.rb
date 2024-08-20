
require 'date/formats'    # DateFormats.parse, find!, ...


require 'csvreader'

def read_csv( path, sep:             nil,
                    symbolize_names: nil )
  opts = {}
  opts[:sep]               = sep         if sep
  opts[:header_converters] = :symbol     if symbolize_names

  CsvHash.read( path, **opts )
end

def parse_csv( txt, sep:             nil,
                    symbolize_names: nil )
  opts = {}
  opts[:sep]               = sep         if sep
  opts[:header_converters] = :symbol     if symbolize_names

  CsvHash.parse( txt, **opts )
end



