

def format(spec)

  ## do a series of regex matches

  ## translate 3-letter month names
  ##  into -> %b   The abbreviated month name ("Jan")

  ## translate full month names
  ## into -> %B  The full month name ("January")

  ## translate 3-letter day names
  ##  into ->  %a  The abbreviated weekday name ("Sun")

  ## translate full day names
  ## into ->  %A  The full weekday name ("Sunday")

  ## translate 01/02/03/04/...09 day
  ##  into -> %d  Day of the month (01..31)

  ## translate 1/2/3/4/5/9 day
  ## into ->  %e  Day of the month without a leading zero (1..31)

  ## translate 2000-2021  year
  ## into -> %Y   Year with century

  ## translate 11:44   hours and minutes
  ##  into ->  %H  Hour of the day, 24-hour clock (00..23)
  ##           %M  Minute of the hour (00..59)
end


## test with
#    February 14, 2020
#    Fri, Feb 14
#    14 Feb 2020
#    Friday, February 14, 2020
#    ...
