# encoding: utf-8


class CsvSummaryReport   ## change to CsvPackageSummaryReport - why? why not?

def initialize( pack_or_path )
  if pack_or_path.is_a?( CsvPackage )
    pack = pack_or_path
    @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
  else  ## assume filepath (string)
    path = pack_or_path
    @pack = CsvPackage.new( path )
    pp @pack.find_entries_by_season
  end
end


def build
  buf = ''
  buf << "# Summary\n\n"
  buf << CsvPyramidReport.new( @pack ).build
  buf << "\n\n"
  buf << CsvTeamsReport.new( @pack ).build
  buf << "\n\n"
  buf
end
alias_method :render, :build



def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build
  end
end



## convenience helper
def write
  ## use "default"  package root and filename for path e.g. ./SUMMARY.md
  root = @pack.expand_path( '.' )
  path = "#{root}/SUMMARY.md"
  save( path )
end


end # class CsvSummaryReport
