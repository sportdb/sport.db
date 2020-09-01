module Mono


class Tool
  def self.main( args=ARGV )

   ## note: for now assume first argument is command
   ##  add options later

   cmd = if args.size == 0
           'status'   ## make status "default" command
         else
           args.shift   ## remove first (head) element
         end

   ## note: allow shortcut for commands
   case cmd.downcase
   when 'status', 'stati', 'stat', 's'
      Mono.status
   when 'sync', 'syn', 'sy',  ## note: allow aliases such as install, get & up too
        'get', 'g',
        'install', 'insta', 'inst', 'ins', 'i',
        'up', 'u'
      Mono.sync
   else
     puts "!! ERROR: unknown command >#{cmd}<"
     exit 1
   end

  end  # method self.main
end # class Tool

end # module Mono