module Sports

class Group
      attr_reader :key, :name, :teams

      def initialize( key: nil,
                      name:,
                      teams: )
        @key    = key    ## e.g. A,B,C  or 1,2,3, - note: always a string or nil
        @name   = name
        @teams  = teams
      end

      def pretty_print( printer )
        ## todo/check - how to display/format key - use () or not - why? why not?
        buf = String.new
        buf << "<Group: #{@key ? @key : '?'} - #{@name} "
        buf << @teams.pretty_print_inspect
        buf << ">"

        printer.text( buf )
      end
end  # class Group
end # module Sports
