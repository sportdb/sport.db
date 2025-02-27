module SportDb
class Lexer



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


# e.g. iso-date  -  2011-08-25     
##   note - allow/support ("shortcuts") e.g 2011-8-25  or 2011-8-3 / 2011-08-03 etc. 
DATE_III_RE = %r{
(?<date>
  \b
   (?<year>\d{4})
       -
   (?<month>\d{1,2})
       -
   (?<day>\d{1,2})
  \b
)}ix

## allow (short)"european" style  8.8. 
##   note - assume day/month!!!
DATE_IIII_RE = %r{
(?<date>
  \b
   (?<day>\d{1,2})
       \.
   (?<month>\d{1,2})
       \.
   (?: (?: 
          (?<year>\d{4})        ## optional year 2025 (yyyy)
              |
          (?<yy>\d{2})           ## optional year 25 (yy)
       )
        \b
   )?
)
}ix




#############################################
# map tables
#  note: order matters; first come-first matched/served
DATE_RE = Regexp.union(
   DATE_I_RE,
   DATE_II_RE,
   DATE_III_RE,
   DATE_IIII_RE,    ## e.g. 8.8. or 8.13.79 or 08.14.1973 
)


##
##  add a date parser helper
def self.parse_date( str, start: )
    if m=DATE_RE.match( str )

      year    = m[:year].to_i(10)  if m[:year]
      month   = MONTH_MAP[ m[:month_name].downcase ]   if m[:month_name]
      day     = m[:day].to_i(10)   if m[:day]
      wday    = DAY_MAP[ m[:day_name].downcase ]   if m[:day_name]

      if year.nil?   ## try to calculate year
        year =  if  month > start.month ||
                   (month == start.month && day >= start.day)
                  # assume same year as start_at event (e.g. 2013 for 2013/14 season)
                  start.year
                else
                  # assume year+1 as start_at event (e.g. 2014 for 2013/14 season)
                  start.year+1
                end
      end
      Date.new( year,month,day )
    else
      puts "!! ERROR - unexpected date format; cannot parse >#{str}<"
      exit 1
    end
end



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
#  Jun/25 - 26        - why? why not???  - YES - see blow variant iii!!!

#  Tue Jun/25 + Wed Jun/26   -- NO
#  Jun/25 + Jun/26           -- NO
#  Jun/25 .. 26        - why? why not???
#  Jun/25 to 26        - why? why not???
#  Jun/25 + 26        - add - why? why not???
#  Sun-Wed Jun/23-26  -  add - why? why not???
#  Wed+Thu Jun/26+27 2024  -  add - why? why not???
#
#  maybe use comma and plus for list of dates
#    Tue Jun/25, Wed Jun/26, Thu Jun/27  ??
#    Tue Jun/25 + Wed Jun/26 + Thu Jun/27  ??
#
#   add back optional comma (before) year - why? why not?
#


##
#   todo add plus later on - why? why not?
###   todo/fix  add optional comma (,) before year

### regex note/tip/remindr -  \b () \b MUST always get enclosed in parantheses
##                                     because alternation (|) has lowest priority/binding


DURATION_I_RE =  %r{
(?<duration>
    \b
  (?:
   ## optional day name
   ((?<day_name1>#{DAY_NAMES})
      [ ]
   )?
   (?<month_name1>#{MONTH_NAMES})
      (?: \/|[ ] )
   (?<day1>\d{1,2})
   ## optional year
   (  ,?   # optional comma
      [ ]
      (?<year1>\d{4})
   )?

   ## support + and -  (add .. or such - why??)
   [ ]* - [ ]*

   ## optional day name
   ((?<day_name2>#{DAY_NAMES})
      [ ]
   )?
   (?<month_name2>#{MONTH_NAMES})
      (?: \/|[ ] )
   (?<day2>\d{1,2})
   ## optional year
   (  ,?   # optional comma
      [ ]
      (?<year2>\d{4})
   )?
  )
   \b
)}ix



#   FIX - remove this variant 
#         "standardize on month day [year]" !!!!

=begin
###
#   variant ii
# e.g. 26 July - 27 July
#      26 July, 
XXX_DURATION_II_RE =  %r{
(?<duration>
    \b
  (?
   ## optional day name
   ((?<day_name1>#{DAY_NAMES})
      [ ]
   )?
   (?<day1>\d{1,2})
      [ ]
   (?<month_name1>#{MONTH_NAMES})
   ## optional year
   (  
       [ ]
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
  )
   \b
)}ix
=end


#  variant ii
#  add support for shorthand
#     August 16-18, 2011     
#     September 13-15, 2011
#      October 18-20, 2011
#      March/6-8, 2012
#      March 6-8 2012
#      March 6-8
#     
#   - add support for August 16+17 or such (and check 16+18)
#       use <op> to check if day2 is a plus or range or such - why? why not?

DURATION_II_RE =  %r{
(?<duration>
    \b
   (?:
       (?<month_name1>#{MONTH_NAMES})
           [ /]
        (?<day1>\d{1,2})
             -
        (?<day2>\d{1,2})
          (?:
            ,?     ## optional comma
            [ ]
            (?<year1>\d{4})
          )?     ## optional year   
   )
   \b
)}ix



#############################################
# map tables
#  note: order matters; first come-first matched/served
DURATION_RE = Regexp.union(
   DURATION_I_RE,
   DURATION_II_RE,
)



end  #   class Lexer
end  # module SportDb

