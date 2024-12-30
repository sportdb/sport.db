
class StatusParser


    RUN_RE = /\[
                 (?<text>[^\]]+)
               \]
             /x
    def self.find!( line )
      ## for now check all "protected" text run blocks e.g. []
      ##  puts "line: >#{line}<"

      status = nil

      str = line
      while m = str.match( RUN_RE )
        str = m.post_match  ## keep on processing rest of line/str (a.k.a. post match string)

        ## check for status match
        match_str = m[0]  ## keep a copy of the match string (for later sub)
        text = m[:text].strip
        ## puts "  text: >#{text}<"

        status = parse( text )

        if status
           line.sub!( match_str, "[STATUS.#{status}]" )
           break
        end
      end  # while match

      status
    end # method find!
end

