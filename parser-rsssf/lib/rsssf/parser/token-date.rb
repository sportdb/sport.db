module Rsssf
class Parser
   

 ## note -  support only 5 letter max for now
 ##    now January|February|August etc.
MONTH_LINES = SportDb::Parser.parse_names( <<TXT )
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

MONTH_NAMES = SportDb::Parser.build_names( MONTH_LINES )
# pp MONTH_NAMES
MONTH_MAP   = SportDb::Parser.build_map( MONTH_LINES, downcase: true )
# pp MONTH_MAP


### nnote - only support two or three letters
##    no Tues | Thur | Thurs | Sunday etc.
DAY_LINES = SportDb::Parser.parse_names( <<TXT )
Mon  Mo
Tue  Tu
Wed  We
Thu  Th
Fri  Fr
Sat  Sa
Sun  Su
TXT


DAY_NAMES = SportDb::Parser.build_names( DAY_LINES )
# pp DAY_NAMES
DAY_MAP   = SportDb::Parser.build_map( DAY_LINES, downcase: true )
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
   
