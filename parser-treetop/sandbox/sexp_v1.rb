## s-expresion parser sample
##   see http://thingsaaronmade.com/blog/a-quick-intro-to-writing-a-parser-using-treetop.html


require 'treetop'

module Sexp

  class IntegerLiteral < Treetop::Runtime::SyntaxNode
        def to_array
          return self.text_value.to_i
       end
   end
      
       class StringLiteral < Treetop::Runtime::SyntaxNode
        def to_array
          return eval self.text_value
       end
      end
      
     class FloatLiteral < Treetop::Runtime::SyntaxNode
        def to_array
          return self.text_value.to_f
        end
      end
      
      class Identifier < Treetop::Runtime::SyntaxNode
        def to_array
          return self.text_value.to_sym
        end
      end
     
      class Expression < Treetop::Runtime::SyntaxNode
        def to_array
         return self.elements[0].to_array
        end
      end
      
      class Body < Treetop::Runtime::SyntaxNode
        def to_array
          return self.elements.map {|x| x.to_array}
        end
      end
end



class Parser

    Treetop.load( 'sandbox/sexp_v0.tt' )


def self.parse(data)
         # Pass the data over to the parser instance
         parser = SexpParser.new
         tree = parser.parse(data)
         
         # If the AST is nil then there was an error during parsing
        # we need to report a simple error message to help the user
        if tree.nil?
          raise Exception, "Parse error at offset: #{parser.index}"
        end
        clean_tree( tree )
        tree
end

def self.clean_tree(root_node)
       return if(root_node.elements.nil?)

       root_node.elements.delete_if do |node| 
         node.class.name == "Treetop::Runtime::SyntaxNode" 
       end

        root_node.elements.each do |node| 
            clean_tree(node) 
        end
end
end




txt = '(this "is" a test( 1 2 3))' 
pp txt

## pp Parser.parse( "" )
## puts "---"
tree = Parser.parse( txt )
pp tree 
puts "---"
pp tree.to_array


puts "bye"