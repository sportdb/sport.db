##
##  to be done

##  up and downs by season


def build__to_be_done

    ## find previous/last season if available for diff
      ## fix/todo: only works for single datafiles for now!!!
      ##   make more "generic" - how???
      if @prev_season
        prev_datafiles = @prev_season.levels[level_key]
        if prev_datafiles && datafiles.size == 1      ## note: level might be missing in prev season!!
          ## buf << "    - diff #{season_key} <=> #{prev_season_key}:\n"
          prev_matchlist = @all_datafiles[ prev_datafiles[0] ]  ## work with first datafile only for now

          diff_plus   = (matchlist.teams - prev_matchlist.teams).sort
          diff_minus  = (prev_matchlist.teams -  matchlist.teams).sort

          buf << "      - (++) new in season #{@season.name}: "
          buf << "(#{diff_plus.size}) #{diff_plus.join(', ')}\n"

          buf << "      - (--) out "
          if level_key == 1    ## todo: check level_key is string or int?
            buf << "down: "
          else
            buf << "up/down: "   ## assume up/down for all other levels in pyramid
          end
          buf << "(#{diff_minus.size}) #{diff_minus.join(', ')}\n"
          buf << "\n"
        end
      end
end
