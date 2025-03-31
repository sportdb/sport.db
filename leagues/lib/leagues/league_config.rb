
module SportDb
class LeagueConfig   

def self.read( path )
   recs = read_csv( path )
   new( recs )
end

def initialize( recs=nil )
   @table = {}
   add( recs )  if recs
end


class LeagueItem
    def initialize
       @recs = []
    end
    def add( rec ) @recs << rec; end
    alias_method :<<, :add

    def find_by_season( season )
        @recs.each do |rec|
            start_season = rec['start_season']
            end_season   = rec['end_season']
            return rec  if (start_season.nil? || start_season <= season) &&
                           (end_season.nil? || end_season >= season)
        end
        nil
    end


    def name_by_season( season )
        rec = find_by_season( season )
        rec ? rec['name'] : nil
    end

    def basename_by_season( season )
        rec = find_by_season( season )
        rec ? rec['basename'] : nil
    end


    def [](key)
        ## short cut - if only one or zero rec
        ##   return directly
        if @recs.empty?
            nil
        elsif @recs.size == 1 &&
              @recs[0]['start_season'].nil? &&
              @recs[0]['end_season'].nil?
            @recs[0][key.to_s]
        else   ### return proc that requires season arg
            case key.to_sym
            when :name      then  method(:name_by_season).to_proc
            when :basename  then  method(:basename_by_season).to_proc
            else
                nil  ## return nil - why? why not?
                ## raise ArgumentError, "invalid key #{key}; use :name or :basename"
            end
        end
    end
end

def add( recs )
   recs.each do |rec|
      key = LeagueCodes.norm( rec['code'] )
      @table[ key ] ||= LeagueItem.new

      ## note: auto-change seasons to season object or nil
      @table[ key ] << {  'code'         => rec['code'],
                          'name'         => rec['name'],
                          'basename'     => rec['basename'],
                          'start_season' => rec['start_season'].empty? ? nil : Season.parse( rec['start_season'] ),
                          'end_season'   => rec['end_season'].empty?   ? nil : Season.parse( rec['end_season'] ),
                       }
   end
end


def []( code )
    key = LeagueCodes.norm( code )
    @table[ key ] 
end

end # class LeagueConfig
end # module SportDb