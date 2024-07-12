

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
DATE_RE = /
(?<date>
  \b
     ((?<day_name>#{DAY_NAMES})
        \s
     )?    ## optional day name
     (?<month_name>#{MONTH_NAMES})
        (?: \/|\s )
     (?<day>\d{1,2})
     ( \s
        (?<year>\d{4})
     )?   ## optional year
  \b   
)
/ix


