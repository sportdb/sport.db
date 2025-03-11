####
#  to run use:
#    $ ruby sandbox/test_score_note.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


SCORE_NOTE_RE  = SportDb::Lexer::SCORE_NOTE_RE


texts = [## try some
            '[aet]',
            '[after extra time]',
            '[a.e.t.]',
            '[ aet ]',
            '[aet; wins 5-1 on pens]',
            '[wins 5-1 on pens]',
            '[wins 5-1 on penalties]',
            '[Ajax wins 5-1 on penalties]',
            '[Ajax wins on away goals]',  ### allow without agg 4-4,  - why? why not?
            '[agg 4-4, Ajax wins on away goals]',
            '[agg 4-3]',
            '[agg 1-2]',
            '[aet; 4-3 pen]',
            '[aet, 4-3p]',
            '[wins on away goals]', ## not valid - requires team
            '[wins on aggregate]',
            '[wins 5-3 on aggregate]',
            '[win 5-3 on aggregate]',
            '[aet; ITA wins 4-3 on pens]',
            '[ITA wins 4-3 on pens]',

            ### add more
            ##   - allow WITHOUT win e.g. 2-4 on penalties ??
            ##          use    2-4 pen          ??
            ##          or     agg 2-2; 2-4 pen ??
            '[2-2 on aggregate; wins 2-4 on penalties]',  ## todo - add to regex
            ##  add won too!!!
            '[Switzerland won 5-4 on penalties]',

            ## check from internationsls
            '[Iraq wins on penalties]',

         ]

texts.each do |text|
  puts "==> #{text}"
  m=SCORE_NOTE_RE.match( text )

  if m
    pp m
  else
    puts "!! note NOT matching"
  end
end



puts "bye"