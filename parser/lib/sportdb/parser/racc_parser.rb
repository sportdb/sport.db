
####
#   RaccMatchParser support machinery (incl. node classes/abstract syntax tree)

class RaccMatchParser


def initialize( txt,  debug: false )
    ## puts "==> txt:"
    ## puts txt
 
    @tree   = [] 
    @errors = []

    ### todo:
    ##  -  pass along debug flag
    lexer = SportDb::Lexer.new( txt, debug: debug )
    ##  note - use tokenize_with_errors and add/collect tokenize errors
    @tokens, @errors = lexer.tokenize_with_errors
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


  def debug( value ) @debug = value; end
  def debug?()  @debug == true; end

  ## debug - trace / print message
  def trace( msg )
     puts "  [parse] " + msg    if debug?
  end




  def next_token
    tok = @tokens.shift
    trace( "next_token => #{tok.pretty_inspect}" )
    tok
  end
  
#  on_error do |error_token_id, error_value, value_stack|
#      puts "Parse error on token: #{error_token_id}, value: #{error_value}"
#  end  

  def parse_with_errors    
     trace( "start parse:" )
     do_parse
     [@tree, @errors]
  end

  def parse  ## convenience shortcut (ignores errors)
    tree, _ = parse_with_errors
    tree 
  end


  attr_reader :errors
  def errors?()   @errors.size > 0; end


  def on_error(error_token_id, error_value, value_stack)
    ## auto-add error_token (as string)
    error_token = Racc_token_to_s_table[error_token_id] 
    args = [error_token, error_token_id, error_value, value_stack]
    puts
    puts "!! on parse error:"
    puts "args=#{args.pretty_inspect}"

    @errors << "parse error on token: #{error_token} (#{error_token_id}) with value: #{error_value}, stack: #{value_stack.pretty_inspect}" 
    ## exit 1  ##   exit for now  -  get and print more info about context etc.!!
  end


=begin
on_error do |error_token_id, error_value, value_stack|
    puts "Parse error on token: #{error_token_id}, value: #{error_value}"
end
=end
end   # class RaccMatchParser