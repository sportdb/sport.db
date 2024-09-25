  # note: normalize names e.g. downcase and remove all non a-z chars (e.g. space, dash, etc.)
  KNOWN_STAGES = [
    'Regular Season',
    'Regular Stage',
    'Championship Round',
    'Championship Playoff',  # or Championship play-off
    'Relegation Round',
    'Relegation Playoff',
    'Play-offs',
    'Playoff Stage',
    'Grunddurchgang',
    'Finaldurchgang - Qualifikationsgruppe',
    'Finaldurchgang - Qualifikation',
    'Finaldurchgang - Meistergruppe',
    'Finaldurchgang - Meister',
    'EL Play-off',
    'Europa League Play-off',
    'Europa-League-Play-offs',
    'Europa League Finals',
    'Playoffs - Championship',
    'Playoffs - Europa League',
    'Playoffs - Europa League - Finals',
    'Playoffs - Relegation',
    'Playoffs - Challenger',
    'Finals',
    'Match 6th Place',  # e.g. Super League Greece 2012/13

    'Apertura',
    'Apertura - Liguilla',
    'Clausura',
    'Clausura - Liguilla',

  ].map {|name| name.downcase.gsub( /[^a-z]/, '' ) }


  def check_stage( name )
    # note: normalize names e.g. downcase and remove all non a-z chars (e.g. space, dash, etc.)
    if KNOWN_STAGES.include?( name.downcase.gsub( /[^a-z]/, '' ) )
       ## everything ok
    else
      puts "** !!! ERROR - no (league) stage match found for >#{name}<, add to (builtin) stages table; sorry"
      exit 1
    end
  end

