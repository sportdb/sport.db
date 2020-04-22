module SportDb
  module Import

    class Round
      attr_reader   :title
      attr_accessor :pos   # note: make read & writable

      ##
      ##  todo:  change db schema
      ##    make start and end date optional
      ##    change pos to num - why? why not?
      ##    make pos/num optional too
      ##
      ##    sort round by scheduled/planed start date
      def initialize( pos:, title: )
        @pos   = pos
        @title = title
      end
    end  # class Round

  end # module Import
end # module SportDb

