###
#  catalog tokenizer sample from
#    - https://martinfowler.com/bliki/HelloRacc.html


require 'strscan'

def make_tokens( str )
    result = []
    scanner = StringScanner.new str
    until scanner.empty?
      case
        when scanner.scan(/\s+/)
          # ignore whitespace
        when match = scanner.scan(/item/)
          result << ['item', nil]
        when match = scanner.scan(/\w+/)
          result << [:WORD, match]
        else
          raise "can't recognize  <#{scanner.peek(5)}>"
      end
    end
    result << [false, false]
    return result
end



