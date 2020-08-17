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
    end  # class Group

end # module Sports

