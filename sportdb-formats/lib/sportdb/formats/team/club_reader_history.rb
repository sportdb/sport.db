# encoding: utf-8


module SportDb
module Import


class ClubHistoryReader

  def catalog() Import.catalog; end



def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
  txt = File.open( path, 'r:utf-8' ) { |f| f.read }
  parse( txt )
end

def self.parse( txt )
  new( txt ).parse
end

def initialize( txt )
  @txt = txt
end


###
## RENAME/RENAMED
## MOVE/MOVED
## BANKRUPT/BANKRUPTED
## REFORM/REFORMED
## MERGE/MERGED    - allow + or ++ or +++ or ; for "inline" - why? why not?


KEYWORD_LINE_RE = %r{ ^(?<keyword>RENAMED?|
                               MOVED?|
                               BANKRUPT(?:ED)?|
                               REFORM(?:ED)?|
                               MERGED?
                    )
                      [ ]+
                     (?<text>.*)    # rest of text
                    $
                  }x


def parse
  recs = []
  last_rec  = nil

  last_country = nil
  last_season  = nil
  last_keyword = nil
  last_teams   = []

  OutlineReader.parse( @txt ).each do |node|
    if [:h1,:h2,:h3,:h4,:h5,:h6].include?( node[0] )
      heading_level  = node[0][1].to_i
      heading        = node[1]

      puts "heading #{heading_level} >#{heading}<"


        if heading_level == 1
            ## assume country in heading; allow all "formats" supported by parse e.g.
            ##   Österreich • Austria (at)
            ##   Österreich • Austria
            ##   Austria
            ##   Deutschland (de) • Germany
            country = catalog.countries.parse( heading )
            ## check country code - MUST exist for now!!!!
            if country.nil?
              puts "!!! error [club history reader] - unknown country >#{heading}< - sorry - add country to config to fix"
              exit 1
            end
            puts "  country >#{heading}< => #{country.name}, #{country.key}"
            last_country = country
            last_season  = nil  ## reset "lower levels" - season & keyword
            last_keyword = nil
         elsif heading_level == 2
            ## assume season
            season = Season.parse( heading )
            puts "  season >#{heading}< => #{season.key}"
            last_season  = season  ## reset "lowwer levels" - keyword
            last_keyword = nil
         else
            puts "!!! ERROR [club history reader] - for now only heading 1 & 2 supported; sorry"
            exit 1
         end

    elsif node[0] == :p   ## paragraph with (text) lines
      if last_country.nil?
        puts "!!! ERROR [club history reader] - country heading 1 required, sorry"
        exit 1
      end
      if last_season.nil?
        puts "!!! ERROR [club history reader] - season heading 2 required, sorry"
        exit 1
      end

      lines = node[1]
      lines.each do |line|
        if m=line.match(KEYWORD_LINE_RE)   ## extract keyword and continue
          keyword = m[:keyword]
          line    = m[:text].strip

          puts "    keyword #{keyword}"
          last_keyword = case keyword   ## "normalize" keywords
                         when 'BANKRUPT', 'BANKRUPTED'
                           'BANKRUPT'
                         when 'RENAME', 'RENAMED'
                           'RENAME'
                         when 'REFORM', 'REFORMED'
                           'REFORM'
                         when 'MOVE',   'MOVED'
                           'MOVE'
                         when 'MERGE',  'MERGED'
                           'MERGE'
                         else
                           puts "!!! ERROR [club history reader] - unexpected keyword >#{keyword}<; sorry - don't know how to normalize"
                           exit 1
                         end

          last_teams   = []
        end

        if last_keyword.nil?
          puts "!!! ERROR [club history reader] - line with keyword expected - got:"
          puts line
          exit 1
        end

        if    last_keyword == 'BANKRUPT'
           ## requires / expects one team in one line
           recs << [ last_keyword, last_season.key,
                     [ squish(line), last_country.key ]
                   ]
        elsif last_keyword == 'RENAME' ||
              last_keyword == 'REFORM' ||
              last_keyword == 'MOVE'
           ## requires / expects two teams in one line (separated by ⇒ or such)
           teams = line.split( '⇒' )
           if teams.size != 2
            puts "!!! ERROR [club history reader] - expected two teams - got:"
            pp teams
            exit 1
           end
           teams = teams.map {|team| squish(team.strip) }  ## remove whitespaces
           recs << [ last_keyword, last_season.key,
                     [ teams[0], last_country.key ],
                     [ teams[1], last_country.key ]
                   ]
        elsif last_keyword == 'MERGE'
            ## check if line starts with separator
            ## otherwise collect to be merged teams
            if line.start_with?( '⇒' )
              if last_teams.size < 2
                puts "!!! ERROR [club history reader] - expected two or more teams for MERGE - got:"
                pp last_teams
                exit 1
              end
              ## auto-add country to all teams
              teams = last_teams.map {|team| [team, last_country.key]}
              recs << [ last_keyword, last_season.key,
                        teams,
                        [ squish(line.sub('⇒','').strip), last_country.key ]
                      ]

              last_teams = []
            else
              last_teams << squish(line)
            end
        else
          puts "!!! ERROR [club history reader] - unknown keyword >#{last_keyword}<; cannot process; sorry"
          exit 1
        end
      end  # each line (in paragraph)
    else
      puts "** !!! ERROR [club history reader] - unknown line type:"
      pp node
      exit 1
    end
  end

  recs
end  # method read


###############
## helper

def squish( str )
  ## colapse all whitespace to one
  str.gsub( /[ ]+/,' ' )
end


end  # class ClubHistoryReader


end ## module Import
end ## module SportDb
