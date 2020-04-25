module SportDb
  module Import

    class Round
      attr_reader   :title, :start_date, :end_date, :knockout
      attr_accessor :pos   # note: make read & writable

      ##
      ##  todo:  change db schema
      ##    make start and end date optional
      ##    change pos to num - why? why not?
      ##    make pos/num optional too
      ##
      ##    sort round by scheduled/planed start date
      def initialize( title:,
                      pos: nil,
                      start_date: nil,
                      end_date: nil,
                      knockout: false,
                      auto: true )
        @title      = title
        @pos        = pos
        @start_date = start_date
        @end_date   = end_date
        @knockout   = knockout
        @auto       = auto        # auto-created (inline reference/header without proper definition before)
      end
    end  # class Round

  end # module Import
end # module SportDb

