module SportDb
class TxtMatchWriter



##  helper - to calculate match stats e.g.
##              how many stages, start and end dates, etc.
def self._calc_stats( matches )
  ### check for stages & stats
  stats = {  'stage'     => Hash.new(0),
             'date'      =>  { 'start_date' => nil,
                               'end_date'   => nil, },
             'teams'     => Hash.new(0),
             'matches'    => 0,
             'use_stages' => false,
          }

  ## add matches played stats too??
  ##   for now only simply count used
  stats['matches'] = matches.size

  matches.each do |match|
     stage = match.stage
     stage = 'Regular Season'   if stage.nil? || stage.empty?
     stats['stage'][ stage ] += 1

     ## note - date for now optional (not required)!!!!
     ##            only teams for match
     if match.date
      ## todo/fix - norm date (parse as Date)
      ##   check format etc.
      date = if match.date.is_a?( String )
                Date.strptime( match.date, '%Y-%m-%d' )
              else  ## assume it's already a date (object)
                match.date
              end
       stats['date']['start_date'] ||= date
       stats['date']['end_date']   ||= date

       stats['date']['start_date'] = date  if date < stats['date']['start_date']
       stats['date']['end_date']   = date  if date > stats['date']['end_date']
     end

     [match.team1, match.team2].each do |team|
        stats['teams'][ team ] += 1    if team && !['N.N.'].include?( team )
     end
  end

  ## add & update use_stage flag
  stats['use_stages']  =  if stats['stage'].size >= 2  ||
                            (stats['stage'].size == 1  &&
                             stats['stage'].keys[0] != 'Regular Season')
                              true
                         else
                              false
                         end
  stats
end

def self._build_stats( stats )
 ### add comment header
 buf = String.new
 # e.g. 13 April – 25 September 2024
 #  or  16 August 2024 – 25 May 2025
 ## note - date is optional!!
 if stats['date']['start_date']
   buf << "# Date       "
   start_date = stats['date']['start_date']
   end_date   = stats['date']['end_date']
   if start_date.year != end_date.year
     buf << "#{start_date.strftime('%a %b %-d %Y')} - #{end_date.strftime('%a %b %-d %Y')}"
   else
     buf << "#{start_date.strftime('%a %b %-d')} - #{end_date.strftime('%a %b %-d %Y')}"
   end
   buf << " (#{end_date.jd-start_date.jd}d)"   ## add days
   buf << "\n"
 end

 buf << "# Teams      #{stats['teams'].size}\n"
 buf << "# Matches    #{stats['matches']}\n"

 if stats['use_stages']
   buf << "# Stages     "
   stages = stats['stage'].map { |name,count| "#{name} (#{count})" }.join( '  ' )
   buf << stages
   buf << "\n"
 end

  buf
end



end # class TxtMatchWriter
end # module SportDb
