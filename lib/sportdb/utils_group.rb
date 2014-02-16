# encoding: utf-8

module SportDb
  module FixtureHelpers

  def is_group?( line )
    # NB: check after is_round? (round may contain group reference!)
    line =~ SportDb.lang.regex_group
  end

  def find_group_title_and_pos!( line )
    ## group pos - for now support single digit e.g 1,2,3 or letter e.g. A,B,C or HEX
    ## nb:  (?:)  = is for non-capturing group(ing)
    regex = /(?:Group|Gruppe|Grupo)\s+((?:\d{1}|[A-Z]{1,3}))\b/
    
    match = regex.match( line )
    
    return [nil,nil] if match.nil?

    pos = case match[1]
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
          else  match[1].to_i
          end

    title = match[0]

    logger.debug "   title: >#{title}<"
    logger.debug "   pos: >#{pos}<"
      
    line.sub!( regex, '[GROUP|TITLE+POS]' )

    return [title,pos]
  end



  end # module FixtureHelpers
end # module SportDb