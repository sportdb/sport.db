
## use Catalog :: PersonDb or such
##     Catalog :: FootballDb or such
##     Catalog :: Football::PersonDb or such 
##
##   person model kind of generic BUT
##    for now incl. shortcuts
##      use pos(istions) (for "role") e.g.
##             - g (gk) - goalkeeper
##             - d (d)  - defence
##             - m (mf) - midfielder
##             - f (fw) - forward
##    for now only one pos possibly (make more generic? with join table?)
##     add a coach (c) - flag and other roles
##         e.g. manager / co-coach / referee / etc.

module CatalogDb
  module PersonDb     ## use nested PersonDb - why? why not?


def self.open( path='./players.db' )
    config = {
        adapter:  'sqlite3',
        database: path,
    }

    ##
    ## todo/fix - check - how to use
    ##    multiple db connections
    ActiveRecord::Base.establish_connection( config )
    # ActiveRecord::Base.logger = Logger.new( STDOUT )

    ## if sqlite3 add (use) some pragmas for speedups
    if config[:database] != ':memory:'
      ## note: if in memory database e.g. ':memory:' no pragma needed!!
      ## try to speed up sqlite
      ##   see http://www.sqlite.org/pragma.html
      con = ActiveRecord::Base.connection
      con.execute( 'PRAGMA synchronous=OFF;' )
      con.execute( 'PRAGMA journal_mode=OFF;' )
      con.execute( 'PRAGMA temp_store=MEMORY;' )
    end

    ##########################
    ### auto_migrate
    unless Model::Person.table_exists?
        CreateDb.new.up
    end
end



class CreateDb
def up
  ActiveRecord::Schema.define do

##############
# person tables   (use people for plular - why? why not?)
create_table :persons do |t|
  t.string :name,   null: false
  t.string :alt_names

  t.string :nat,    null: false    ## make required - why? why not?
  ## add optinal nat2/nat3  - nationality (use three+ letter downcase country codes)

  ## use birth_date and birth_place (with or without _) - why? why not?
  t.date   :birthdate     # rename to d.o.b. - date of birth (optional)
  t.string :birthplace    # note - birth place/city for now string

  t.integer :height   ## in cm (e.g. 180 cm, 200cm, 177cm, etc.)
 
  ### 
  ##   check if activerecord can deal with "custom" pos
  ##    that is, is pos reserved for (default) order or such???
  t.string :pos   

  ##  note - always auto-generated for now
  ##   and used in read-only mode (no need to track timestamps, no?)
  ## t.timestamps  ## (auto)add - why? why not?
end

## note - do not use own id - it's a "join" table
create_table :person_names, id: false  do |t|
  t.references  :person,  null: false
  t.string      :name,    null: false     ## normalized (lowercase)!!!

  ## note - do NOT add timestaps to names - keep db smaller?
  ##  was 3MB before with timestamps now 2MB for example
  ##         saving 1/3rd or 1MB for 10000 players!!!
  ## t.timestamps  ## (auto)add - why? why not?
end
add_index :person_names, [:person_id, :name], unique: true


  end  # Schema.define
end # method up

end # class CreateDb
end # module PersonDb     ## use nested PersonDb - why? why not?
end # module CatalogDb
