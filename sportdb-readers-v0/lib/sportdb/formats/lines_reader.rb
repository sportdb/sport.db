
module SportDb

class LinesReader   ## change to LinesEnumerator - why? why not?
        def initialize( lines )
            @iter = lines.each  ## get (external) enumerator (same as to_enum)
            @lineno = 0
        end
    
        def each( &blk )
        ## note - StopIteration is rescued (automagically) by Kernel#loop.
        ##            no need to rescue ourselves here
            loop do
              line = @iter.next   ## note - raises StopIteration  
              blk.call( line )
            end
        end
    
        def each_with_index( &blk )
            ## note - StopIteration is rescued (automagically) by Kernel#loop.
                loop do
                  line = @iter.next   ## note - raises StopIteration 
                  blk.call( line, @lineno )
                  @lineno += 1
                end
        end
        
        def peek
            begin  
              @iter.peek
            rescue StopIteration
                nil
            end
        end
    
        def next
            ## todo/check - do NOT catch StopIteration for next - why? why not?
            begin
                line = @iter.next
                @lineno += 1
                line
            rescue StopIteration
                nil
            end
        end    
end  # class LinesReader  
end # module SportDb