def parse_round_def( line )
    pos = find_round_pos!( line )
    logger.debug "    pos:      #{pos}"
end

def parse_round_header( line )
    ## todo/check/fix:
    #   make sure  Round of 16  will not return pos 16 -- how? possible?
    #   add unit test too to verify
    pos = find_round_pos!( line )
end

def find_round_def_name!( line )
    # e.g. remove [ROUND.POS], [ROUND.NAME2], [GROUP.NAME+POS] etc.
    buf.gsub!( /\[[^\]]+\]/, '' )    ## fix: use helper for (re)use e.g. remove_match_placeholder/marker or similar?
    # remove leading and trailing whitespace
end

def find_round_header_name!( line )
    ## todo/fix:
    ##  cleanup method
    ##   use  buf.index( '//' ) to split string (see found_round_def)
    ##     why? simpler why not?
    ##  - do we currently allow groups if name2 present? add example if it works?

    ## todo: use strip_tags or strip_tokens or strip_token_tags or strip_marker or such - why? why not?
    ##  e.g. remove [ROUND.POS], [ROUND.NAME2], [GROUP.NAME+POS] etc.
    ## todo/check: or better use non-greedy (minimal) .+? match - why? why not?
    buf.gsub!( /\[
                  [^\]]+
                \]
                /x, '' )
end



def find_round_pos!( line )
  # pass #1) extract optional round pos from line
  # e.g.  (1)   - must start line
  regex_pos = /^[ \t]*\((\d{1,3})\)[ \t]+/

  # pass #2) find free standing number  e.g. Matchday 3 or Round 5 or 3. Spieltag etc.
  # note: /\b(\d{1,3})\b/
  #   will match -12
  #  thus, use space required - will NOT match  -2 e.g. Group-2 Play-off
  #  note:  allow  1. Runde  n
  #                1^ Giornata
  regex_num = /(?:^|\s)(\d{1,3})(?:[.\^\s]|$)/

  if line =~ regex_pos
    logger.debug "   pos: >#{$1}<"

    line.sub!( regex_pos, '[ROUND.POS] ' )  ## NB: add back trailing space that got swallowed w/ regex -> [ \t]+
    return $1.to_i
  elsif line =~ regex_num
    ## assume number in name is pos (e.g. Jornada 3, 3 Runde etc.)
    ## NB: do NOT remove pos from string (will get removed by round name)

    num = $1.to_i  # note: clone capture; keep a copy (another regex follows; will redefine $1)

    #### fix:
    #  use/make keywords required
    #  e.g. Round of 16  -> should NOT match 16!
    #    Spiel um Platz 3  (or 5) etc -> should NOT match 3!
    #  Round 16 - ok
    #  thus, check for required keywords

    ## quick hack for round of 16
    # todo: mask match e.g. Round of xxx ... and try again - might include something
    #  reuse pattern for Group XX Replays for example
    if line =~ /^\s*Round of \d{1,3}\b/
       return nil
    end

    logger.debug "   pos: >#{num}<"
    return num
  else
    ## fix: add logger.warn no round pos found in line
    return nil
  end
end # method find_round_pos!



def find_group_name_and_pos!( line )
  ## group pos - for now support single digit e.g 1,2,3 or letter e.g. A,B,C or HEX
  ## nb:  (?:)  = is for non-capturing group(ing)

  ## fix:
  ##   get Group|Gruppe|Grupo from lang!!!! do NOT hardcode in place

  ## todo:
  ##   check if Group A:  or [Group A]  works e.g. : or ] get matched by \b ???
  regex = /(?:Group|Gruppe|Grupo)\s+((?:\d{1}|[A-Z]{1,3}))\b/

  m = regex.match( line )

  return [nil,nil] if m.nil?

  pos = case m[1]
        when 'A' then 1
        when 'B' then 2
        when 'C' then 3
        when 'D' then 4
        when 'E' then 5
        when 'F' then 6
        when 'G' then 7
        when 'H' then 8
        when 'I' then 9
        when 'J' then 10
        when 'K' then 11
        when 'L' then 12
        when 'HEX' then 666    # HEX for Hexagonal - todo/check: map to something else ??
        else  m[1].to_i
        end

  name = m[0]

  logger.debug "   name: >#{name}<"
  logger.debug "   pos: >#{pos}<"

  line.sub!( regex, '[GROUP.NAME+POS]' )

  [name,pos]
end
