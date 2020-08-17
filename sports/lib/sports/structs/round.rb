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
    end  # class Round

end # module Sports

