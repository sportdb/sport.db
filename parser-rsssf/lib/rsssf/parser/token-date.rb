module Rsssf
class Parser
   


def self.parse_names( txt )
  lines = [] # array of lines (with words)

  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline (until end-of-line) comments too
    ##   e.g. Janvier  Janv  Jan  ## check janv in use??
    ##   =>   Janvier  Janv  Jan

    line = line.sub( /#.*/, '' ).strip
    ## pp line

    values = line.split( /[ \t]+/ )
    ## pp values

    ## todo/fix -- add check for duplicates
    lines << values
  end
  lines

end # method parse


def self.build_names( lines )
  ## join all words together into a single string e.g.
  ##   January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|...
  lines.map { |line| line.join('|') }.join('|')
end



## add normalize option (for downcase) - why? why not?
def self.build_map( lines )
    ## note: downcase name!!!
   ## build a lookup map that maps the word to the index (line no) plus 1 e.g.
   ##  {"january" => 1,  "jan" => 1,
   ##   "february" => 2, "feb" => 2,
   ##   "march" => 3,    "mar" => 3,
   ##   "april" => 4,    "apr" => 4,
   ##   "may" => 5,
   ##   "june" => 6,     "jun" => 6, ...
   lines.each_with_index.reduce( {} ) do |h,(line,i)|
     line.each { |name| h[ name.downcase ] = i+1 }  ## note: start mapping with 1 (and NOT zero-based, that is, 0)
     h
   end
 end


MONTH_LINES = parse_names( <<TXT )
January    Jan
February   Feb
March      Mar
April      Apr
May
June       Jun
July       Jul
August     Aug
September  Sept  Sep
October    Oct
November   Nov
December   Dec
TXT

MONTH_NAMES = build_names( MONTH_LINES )
# pp MONTH_NAMES
MONTH_MAP   = build_map( MONTH_LINES )
# pp MONTH_MAP



DAY_LINES = parse_names( <<TXT )
Monday                   Mon  Mo
Tuesday            Tues  Tue  Tu
Wednesday                Wed  We
Thursday    Thurs  Thur  Thu  Th
Friday                   Fri  Fr
Saturday                 Sat  Sa
Sunday                   Sun  Su
TXT

DAY_NAMES = build_names( DAY_LINES )
# pp DAY_NAMES
DAY_MAP   = build_map( DAY_LINES )
# pp DAY_MAP


#=>
# "January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|
#  July|Jul|August|Aug|September|Sept|Sep|October|Oct|
#  November|Nov|December|Dec"
#
# "Monday|Mon|Mo|Tuesday|Tues|Tue|Tu|Wednesday|Wed|We|
#  Thursday|Thurs|Thur|Thu|Th|Friday|Fri|Fr|
#  Saturday|Sat|Sa|Sunday|Sun|Su"



## todo - add more date variants !!!!

# e.g. Fri Aug/9  or Fri Aug 9
DATE_RE = %r{
 ## note - do not include [] in capture for now - why? why not
    ## eat-up/consume optional [] - part i
    (?: \[ | \b
     )
(?<date>

     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          [ ]
     )?    
     ##  allow 1 or 2 spaces e.g. Jul  2 / Jun 27 to pretty print
     (?<month_name>#{MONTH_NAMES})
         (?: \/|[ ]{1,2} )
     (?<day>\d{1,2})
     ## optional year
     (  [ ]
        (?<year>\d{4})
     )?   
   )
  ## eat-up/consume optional [] - part ii
  (?: \] | \b
  )        
}ix



end  #   class Parser
end  # module Rsssf
   
