
  def load_fixtures_builtin( event_key, name ) # load from gem (built-in)
    ### todo/fix: use load_teams_with_include_path and pass in SportDB.data_path
    # see worlddb for example
    
    path = "#{SportDB.data_path}/#{name}.txt"

    puts "*** parsing data '#{name}' (#{path})..."

    reader = LineReader.new( logger, path )

    load_fixtures_worker( event_key, reader )
    
    Prop.create!( key: "db.#{fixture_name_to_prop_key(name)}.version", value: "sport.txt.#{SportDB::VERSION}" )
  end
  
 def load_teams_builtin( name, more_values={} )
    ## todo/fix: use load_teams_with_include_path and pass in SportDB.data_path
    path = "#{SportDB.data_path}/#{name}.txt"

    puts "*** parsing data '#{name}' (#{path})..."

    reader = ValuesReader.new( logger, path, more_values )

    load_teams_worker( reader )
    
    Prop.create!( key: "db.#{fixture_name_to_prop_key(name)}.version", value: "sport.txt.#{SportDB::VERSION}" )    
  end  

