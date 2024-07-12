

def build_names( txt )
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

  ## join all words together into a single string e.g.
  ##   January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|...
  lines.map { |line| line.join('|') }.join('|')
end # method parse



MONTH_NAMES = build_names( <<TXT )
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

DAY_NAMES = build_names( <<TXT )
Monday                   Mon  Mo
Tuesday            Tues  Tue  Tu
Wednesday                Wed  We
Thursday    Thurs  Thur  Thu  Th
Friday                   Fri  Fr
Saturday                 Sat  Sa
Sunday                   Sun  Su
TXT



## pp MONTH_NAMES 
## pp  DAY_NAMES 

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
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          [ ]
     )?    
     (?<month_name>#{MONTH_NAMES})
         (?: \/|[ ] )
     (?<day>\d{1,2})
     ## optional year
     (  [ ]
        (?<year>\d{4})
     )?   
  \b   
)}ix


###
#  date duration  
#   use - or + as separator
#    in theory plus( +) only if dates 
#     are two days next to each other
#
#   otherwise  define new dates type in the future? why? why not?
#
#  check for plus (+) if dates are next to each other (t+1) - why? why not?

#
#  Sun Jun/23 - Wed Jun/26   -- YES
#  Jun/23 - Jun/26           -- YES
#  Tue Jun/25 + Wed Jun/26   -- YES
#  Jun/25 + Jun/26           -- YES
#
#  Jun/25 - 26        - why? why not???
#  Jun/25 .. 26        - why? why not???
#  Jun/25 to 26        - why? why not???
#  Jun/25 + 26        - add - why? why not???
#  Sun-Wed Jun/23-26  -  add - why? why not??? 
#  Wed+Thu Jun/26+27 2024  -  add - why? why not???
#
#  maybe use comman and plus for list of dates
#    Tue Jun/25, Wed Jun/26, Thu Jun/27  ??
#    Tue Jun/25 + Wed Jun/26 + Thu Jun/27  ??
#
#   add back optional comma (before) year - why? why not?


DURATION_RE =  %r{
(?<duration>
    \b
   ## optional day name
   ((?<day_name1>#{DAY_NAMES})
      [ ]
   )?    
   (?<month_name1>#{MONTH_NAMES})
      (?: \/|[ ] )
   (?<day1>\d{1,2})
   ## optional year
   ( [ ]
      (?<year1>\d{4})
   )?   

   ## support + and -  (add .. or such - why??)
   [ ]*[+-][ ]*   
  
   ## optional day name
   ((?<day_name2>#{DAY_NAMES})
      [ ]
   )?    
   (?<month_name2>#{MONTH_NAMES})
      (?: \/|[ ] )
   (?<day2>\d{1,2})
   ## optional year
   ( [ ]
      (?<year2>\d{4})
   )?   
   \b   
)}ix



