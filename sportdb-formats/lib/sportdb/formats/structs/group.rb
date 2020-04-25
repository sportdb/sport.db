module SportDb
  module Import

    class Group
      attr_reader   :title, :pos, :teams

      ##
      ##  todo:  change db schema
      ##    make start and end date optional
      ##    change pos to num - why? why not?
      ##    make pos/num optional too
      ##
      ##    sort round by scheduled/planed start date
      def initialize( title:,
                      pos:,
                      teams: )
        @title  = title
        @pos    = pos
        @teams  = teams
      end
    end  # class Group

  end # module Import
end # module SportDb

