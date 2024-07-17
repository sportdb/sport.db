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


 ## note -  support only 5 letter max for now
 ##    now January|February|August etc.
MONTH_LINES = parse_names( <<TXT )
Jan
Feb
March      Mar
April      Apr
May
June       Jun
July       Jul
Aug
Sept       Sep
Oct
Nov
Dec
TXT

MONTH_NAMES = build_names( MONTH_LINES )
# pp MONTH_NAMES
MONTH_MAP   = build_map( MONTH_LINES )
# pp MONTH_MAP


### nnote - only support two or three letters
##    no Tues | Thur | Thurs | Sunday etc.
DAY_LINES = parse_names( <<TXT )
Mon  Mo
Tue  Tu
Wed  We
Thu  Th
Fri  Fr
Sat  Sa
Sun  Su
TXT


DAY_NAMES = build_names( DAY_LINES )
# pp DAY_NAMES
DAY_MAP   = build_map( DAY_LINES )
# pp DAY_MAP



#=>
# "Jan|Feb|March|Mar|April|Apr|May|June|Jun|
#  July|Jul|Aug|Sept|Sep|Oct|Nov|Dec"
#
# "Mon|Mo|Tue|Tu|Wed|We|
#  Thu|Th|Fri|Fr|Sat|Sa|Sun|Su"



## todo - add more date variants !!!!

# e.g.  Fri Aug 9
DATE_RE = %r{
 ## note - do not include [] in capture for now - why? why not
    ## eat-up/consume optional [] - part i
    (?: \[ | \b
     )
(?<date>

     (?:  ######  
          ## variant I/1/one
          ###   Fri June 24 

     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          [ ]
     )?    
     ##  allow 1 or 2 spaces e.g. Jul  2 / Jun 27 to pretty print
     (?<month_name>#{MONTH_NAMES})
         [ ]{1,2}
     (?<day>\d{1,2})
     ## optional year
     (  [ ]
        (?<year>\d{4})
     )?   
     )
    |
     (?: #### 
         ## variant II/2/two
         ##   17- 3-22   - allow space befor mont
         ##   17-3-22
            \d{1,2}
             -
            [ ]*\d{1,2} 
             -
             (?:
                \d{4} |   ## 2024
                \d{2}     ## or 24 only
             )
     )
     )  ## end date capture
  ## eat-up/consume optional [] - part ii
  (?: \] | \b
  )        
}ix



end  #   class Parser
end  # module Rsssf
   
