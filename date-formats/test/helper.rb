## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code

require 'date/formats'     ## or require 'date-formats'


#####################
## add assert helpers for dates
class MiniTest::Test
    def assert_dates( data, start:, lang: 'en' )
      data.each do |rec|
        line         = rec[0]
        str          = rec[1]

        ## note: test / use parse and find!  -- parse MUST go first
        values = []
        values << DateFormats.parse( line, start: start, lang: lang )
        values << DateFormats.find!( line, start: start, lang: lang )

        tagged_line  = rec[2]  ## optinal tagged line
        if tagged_line      ## note: line gets tagged inplace!!! (no new string)
          assert_equal line, tagged_line
          puts "#{line} == #{tagged_line}"
        end

        values.each do |value|
          if str.index( ':' )
            assert_datetime( DateTime.strptime( str, '%Y-%m-%d %H:%M' ), value )
          else
            assert_date( Date.strptime( str, '%Y-%m-%d' ), value )
          end
        end
      end
    end


    ## todo: check if assert_datetime or assert_date exist already? what is the best practice to check dates ???
    def assert_date( exp, value )
      assert_equal exp.year,  value.year
      assert_equal exp.month, value.month
      assert_equal exp.day,   value.day
    end

    def assert_time( exp, value )
      assert_equal exp.hour, value.hour
      assert_equal exp.min,  value.min
    end

    def assert_datetime( exp, value )
      assert_date( exp, value )
      assert_time( exp, value )
    end
end
