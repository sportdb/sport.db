
####
#   RaccMatchParser support machinery (incl. node classes/abstract syntax tree)

class RaccMatchParser


def initialize( txt )
    ## puts "==> txt:"
    ## puts txt
   
    parser = SportDb::Parser.new
    @tokens = parser.tokenize( txt )
    ## pp @tokens
    
    ## quick hack - convert to racc format single char literal tokens e.g. '@' etc.
    @tokens = @tokens.map do |tok|
                 if tok.size == 1
                   [tok[0].to_s, tok[0].to_s]
                 else 
                   tok
                 end
               end
  end
  

  def next_token
    tok = @tokens.shift
    puts "next_token => #{tok.pretty_inspect}"
    tok
  end
  
#  on_error do |error_token_id, error_value, value_stack|
#      puts "Parse error on token: #{error_token_id}, value: #{error_value}"
#  end  

  def parse    
     puts "parse:"
     @tree = [] 
     do_parse
     @tree
  end


  def on_error(*args)
    puts
    puts "!! on parse error:"
    puts "args=#{args.pretty_inspect}"
    exit 1  ##   exit for now  -  get and print more info about context etc.!!
  end


=begin
on_error do |error_token_id, error_value, value_stack|
    puts "Parse error on token: #{error_token_id}, value: #{error_value}"
end
=end
end   # class RaccMatchParser