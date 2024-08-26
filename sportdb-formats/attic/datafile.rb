# encoding: utf-8


module Datafile      # note: keep Datafile in its own top-level module/namespace for now - why? why not?

  def self.read( path )   ## todo/check: use as a shortcut helper - why? why not?
     ## note: always assume utf-8 for now!!!
     File.open( path, 'r:utf-8') {|f| f.read }
  end


  ########################
  ## todo/fix: turn into Datafile::Bundle.new  and Bundle#write/save -why? why not?
  class Bundle
    def initialize( path )
      @path = path
      @buf  = String.new('')
    end

    def <<(value)
       if value.is_a?( Array )  ## assume array of datafiles (file paths)
         datafiles = value
         datafiles.each do |datafile|
           text = Datafile.read( datafile )
           ## todo/fix/check:  move  sub __END__ to Datafile.read and turn it always on  -  why? why not?
           text = text.sub( /__END__.*/m, '' )    ## note: add/allow support for __END__; use m-multiline flag
           @buf << text
           @buf << "\n\n"
          end
        else ## assume string (e.g. header, comments, etc.)
          text = value
          @buf << text
          @buf << "\n\n"
        end
    end
    alias_method :write, :<<

    ## todo/fix/check: write only on close? or write on every write and use close for close?
    def close
      File.open( @path, 'w:utf-8' ) do |f|
        f.write @buf
      end
    end
  end  # class Bundle


  def self.write_bundle( path, datafiles:, header: nil )
    bundle = Bundle.new( path )
    bundle.write( header )   if header
    datafiles.each do |datafile|
      text = read( datafile )
      ## todo/fix/check:  move  sub __END__ to Datafile.read and turn it always on  -  why? why not?
      text = text.sub( /__END__.*/m, '' )    ## note: add/allow support for __END__; use m-multiline flag
      bundle.write( text )
    end
    bundle.close
  end

end # module Datafile
