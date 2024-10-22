module Sports

  class Round
      attr_reader   :name, :start_date, :end_date, :knockout
      attr_accessor :num   # note: make read & writable - why? why not?

      def initialize( name:,
                      num: nil,
                      start_date: nil,
                      end_date: nil,
                      knockout: false,
                      auto: true )
        @name       = name
        @num        = num
        @start_date = start_date
        @end_date   = end_date
        @knockout   = knockout
        @auto       = auto        # auto-created (inline reference/header without proper definition before)
      end

      def pretty_print( printer )
        ## todo/check - how to display/format key - use () or not - why? why not?
        buf = String.new
        buf << "<Round"
        buf << " AUTO"    if @auto
        buf << ": "
        buf << "(#{@num}) "  if @num
        buf << "#{@name}, "
        buf << "#{@start_date}"
        buf << " - #{@end_date}"  if @start_date != @end_date
        buf << "  (knockout)" if @knockout
        buf << ">"

        printer.text( buf )
      end
end  # class Round
end # module Sports

