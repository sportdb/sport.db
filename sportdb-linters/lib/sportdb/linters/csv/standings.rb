# encoding: utf-8


##
#  todo/fix: rename/change to CsvTableWriter  - why? why not?
class CsvStandingsWriter   ## change/rename to CsvStandingsTableWriter/Updater - why? why not?

def initialize( pack )
  @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
end


def write( path: nil )   ## change/rename to recalc / build / etc. - why? why not?
   ## (re)calc standings tables and generate README.md


   if path
     out_root = path      ## e.g. ./o/be-belgium or something for debugging
   else
     ## default to write inrepo directly!!!
     ##  e.g. ../../be-belgium or something
     out_root = @pack.expand_path( '.' )
   end


   season_entries = @pack.find_entries_by_season_dir
   season_entries.each do |season_entry|
     season_dir   = season_entry[0]
     season_files = season_entry[1]    ## .csv (data)files

     puts "season folder: #{season_dir}"
     buf = ""

     season_files.each_with_index do |season_file,i|
       puts "   datafile (#{i+1}/#{season_files.size}): #{season_file}"

       matches   = CsvMatchReader.read( @pack.expand_path( season_file ) )
       standings = SportDb::Import::Standings.new
       standings.update( matches )
       ## pp standings.to_a

       buf << standings.build( source: File.basename(season_file) )
     end


     out_path = "#{out_root}/#{season_dir}/README.md"
     puts "out_path=>#{out_path}<, season_dir=>#{season_dir}<"

     ## make sure parent folders exist
     FileUtils.mkdir_p( File.dirname(out_path) )  unless Dir.exists?( File.dirname( out_path ))

     File.open( out_path, 'w:utf-8' ) do |out|
       out.puts "\n\n"
       out.puts "### Standings\n"
       out.puts "\n"
       out.puts buf
       out.puts "\n"
       out.puts "\n"
       out.puts "---\n"
       out.puts "Pld = Matches; W = Matches won; D = Matches drawn; L = Matches lost; F = Goals for; A = Goals against; +/- = Goal differencence; Pts = Points\n"
       out.puts "\n"
     end
   end
end  # method write

end   ## class CsvStandingsWriter
