module SportDb
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


def self.build_map( lines, downcase: false )
   ## note: downcase name!!!
  ## build a lookup map that maps the word to the index (line no) plus 1 e.g.
  ##  {"january" => 1,  "jan" => 1,
  ##   "february" => 2, "feb" => 2,
  ##   "march" => 3,    "mar" => 3,
  ##   "april" => 4,    "apr" => 4,
  ##   "may" => 5,
  ##   "june" => 6,     "jun" => 6, ...
  lines.each_with_index.reduce( {} ) do |h,(line,i)|
    line.each do |name|
       h[ downcase ? name.downcase : name ] = i+1
    end  ## note: start mapping with 1 (and NOT zero-based, that is, 0)
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
MONTH_MAP   = build_map( MONTH_LINES, downcase: true )
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
DAY_MAP   = build_map( DAY_LINES, downcase: true )
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
DATE_I_RE = %r{
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


# e.g. 3 June  or 10 June
DATE_II_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          [ ]
     )?
     (?<day>\d{1,2})
         [ ]
     (?<month_name>#{MONTH_NAMES})
     ## optional year
     (  [ ]
        (?<year>\d{4})
     )?
  \b
)}ix


#############################################
# map tables
#  note: order matters; first come-first matched/served
DATE_RE = Regexp.union(
   DATE_I_RE,
   DATE_II_RE
)


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


##
#   todo add plus later on - why? why not?

DURATION_I_RE =  %r{
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
   [ ]*[-][ ]*

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


###
#   variant ii
# e.g. 26 July - 27 July

DURATION_II_RE =  %r{
(?<duration>
    \b
   ## optional day name
   ((?<day_name1>#{DAY_NAMES})
      [ ]
   )?
   (?<day1>\d{1,2})
      [ ]
   (?<month_name1>#{MONTH_NAMES})
   ## optional year
   ( [ ]
      (?<year1>\d{4})
   )?

   ## support + and -  (add .. or such - why??)
   [ ]*[-][ ]*

   ## optional day name
   ((?<day_name2>#{DAY_NAMES})
      [ ]
   )?
   (?<day2>\d{1,2})
      [ ]
   (?<month_name2>#{MONTH_NAMES})
   ## optional year
   ( [ ]
      (?<year2>\d{4})
   )?
   \b
)}ix


#############################################
# map tables
#  note: order matters; first come-first matched/served
DURATION_RE = Regexp.union(
   DURATION_I_RE,
   DURATION_II_RE
)



end  #   class Parser
end  # module SportDb

