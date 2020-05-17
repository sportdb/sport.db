#####
# auto-load/require some addons

## puts 'before auto-load (require) sportdb addons'
## puts '  before sportdb/update'
## require 'sportdb/update'

puts '  before sportdb/service'
require 'sportdb/service'
puts 'after auto-load (require) sportdb addons'



desc 'Start web service (HTTP JSON API)'
command [:serve,:server] do |c|

  c.action do |g,o,args|

    connect_to_db( opts )

    # note: server (HTTP service) not included in standard default require
    ##   -- note - now included!!!
    ## require 'sportdb/service'

# make sure connections get closed after every request e.g.
#
#  after do
#   ActiveRecord::Base.connection.close
#  end
#

    ## note:  ConnectionManagement removed from ActiveRecord 4+
    ##   see github.com/rails/rails/issues/26947
    ## puts 'before add middleware ConnectionManagement'
    ## SportDb::Service::Server.use ActiveRecord::ConnectionAdapters::ConnectionManagement
    ## puts 'after add middleware ConnectionManagement'
    ## todo: check if we can check on/dump middleware stack

    ## rack middleware might not work with multi-threaded thin web server; close it ourselfs
    SportDb::Service::Server.after do
      puts "  #{Thread.current.object_id} -- make sure db connections gets closed after request"
      # todo: check if connection is open - how?
      ActiveRecord::Base.connection.close
    end

    SportDb::Service::Server.run!

    puts 'Done.'
  end
end # command serve

