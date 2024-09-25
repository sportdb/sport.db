

 ## todo/fix
 ##  ** !!! ERROR - too many matches (2) for club >Barcelona<:
 ## [<Club: FC Barcelona (ESP)>, <Club: Barcelona Guayaquil (ECU)>]


    if league.clubs? && league.intl?    ## todo/fix: add intl? to ActiveRecord league!!!

        ## quick hack - use "dynamic" keys for keys
          uefa_el_q = Import::League.match_by( code: 'uefa.el.quali' )[0]
          uefa_cl_q = Import::League.match_by( code: 'uefa.cl.quali' )[0]
          uefa_cl   = Import::League.match_by( code: 'uefa.cl' )[0]
          uefa_el   = Import::League.match_by( code: 'uefa.el' )[0]

          pp [uefa_el_q, uefa_cl_q, uefa_cl, uefa_el]

                ### quick hack mods for popular/known ambigious club names
                ##    todo/fix: make more generic / reuseable!!!!
                mods = {}
                ## europa league uses same mods as champions league
                mods[ uefa_el_q.key ] =
                mods[ uefa_cl_q.key ] =
                mods[ uefa_el.key ] =
                mods[ uefa_cl.key ] = catalog.clubs.build_mods(
                  { 'Liverpool | Liverpool FC' => 'Liverpool FC, ENG',
                    'Arsenal  | Arsenal FC'    => 'Arsenal FC, ENG',
                    'Barcelona'                => 'FC Barcelona, ESP',
                    'Valencia'                 => 'Valencia CF, ESP',
                    'Rangers FC'               => 'Rangers FC, SCO',
                  })
       end

