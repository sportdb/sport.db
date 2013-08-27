
module SportDb

  class Updater
    ######
    # NB: make models available in sportdb module by default with namespace
    #  e.g. lets you use Team instead of Models::Team 
    include SportDb::Models


    def map_event_to_dlurl( event )

      repo_path, folder_path = map_key_to_repo_n_folder_path( event.league.key )
      return nil if repo_path.nil?   # no match/mapping found; cancel download

      season_path = event.season.key.gsub( '/', '_')  # convert 2013/14 to 2013_14

      ###
      # e.g. https://raw.github.com/openfootball/at-austria/master/2013_14/bl.txt

      dlurl = "https://raw.github.com/openfootball/#{repo_path}/master"
      dlurl << "/#{folder_path}" if folder_path.present?
      dlurl << "/#{season_path}"
      dlurl
    end


    def map_key_to_repo_n_folder_path( key )

      ### allow * for regex match w/ .+
      map = [
        [ 'at',      'at-austria'  ],
        [ 'at.*',    'at-austria'  ],
        [ 'de',      'de-deutschland' ],
        [ 'be',      'europe', 'be-belgium' ], # NB: europe/be-belgium
        [ 'cl',      'europe'      ],
        [ 'world.*', 'world-cup'  ]]

      map.each do |entry|
         pattern = entry[0]
         path    = [ entry[1], entry[2] ]  # repo n folder path
         
         if pattern.index( '*' ).nil?  # match just plain string (no wildcard *)
           return path if key == pattern
         else
           # assume regex match
           regex = pattern.gsub( '.', '\.' ).gsub( '*', '.+' )
           return path if key =~ /#{regex}/
         end
      end
      nil  # return nil; no match found
    end

    def update_event( event )
      puts "update event >>#{event.title}<< (#{event.league.key}+#{event.season.key})"

      dlbase = map_event_to_dlurl( event )
      if dlbase.nil?
        puts "  skip download; no download source mapping found"
        return  # cancel download; no mapping found
      end

      puts "  using dlbase >>#{dlbase}<<"

      if event.sources.nil?
        puts "  skip download; no download event source configured/found"
        return
      end
      
      sources = event.sources.split(',')
      sources.each_with_index do |source,i|
        dlurl = "#{dlbase}/#{source}.txt"
        puts "   downloading source (#{i+1}/#{sources.length}) >>#{dlurl}<< ..."     # todo/check: use size for ary or length - does it matter?

        # download fixtures into string
        text = Fetcher.read( dlurl )

        puts "   importing/reading source..."
        reader= Reader.new( '/tmp' )  # passing dummy include_path (not needed for reading from string)
        
        ## todo/fix: offer a version that lets us pass in event (not event.key)
        #    no need for another event lookup
        reader.load_fixtures_from_string( event.key, text )
      end
    end


    def run
      # for now update all events (fixtures only) - not *.yml

      Event.all.each do |event|
        update_event( event )
      end

    end
    
  end # class Updater
  
end # module SportDb