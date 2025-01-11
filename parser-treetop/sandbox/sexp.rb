## s-expresion parser sample
##   see http://thingsaaronmade.com/blog/a-quick-intro-to-writing-a-parser-using-treetop.html


require 'treetop'

module Sexp
    class IntegerLiteral < Treetop::Runtime::SyntaxNode
    end
          
          class StringLiteral < Treetop::Runtime::SyntaxNode
          end
          
          class FloatLiteral < Treetop::Runtime::SyntaxNode
          end
         
          class Identifier < Treetop::Runtime::SyntaxNode
          end
         
         class Expression < Treetop::Runtime::SyntaxNode
         end
        
         class Body < Treetop::Runtime::SyntaxNode
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
pp Parser.parse( txt )



puts "bye"