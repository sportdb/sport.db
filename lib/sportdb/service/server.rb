
module SportDb::Service

class Server < Sinatra::Base

  ######
  # allow cross site json requests (e.g. url posting on rubyflow - avoid crash!!)
  #  see
  #   http://www.sinatrarb.com/intro.html#Configuring attack protection
  #  todo: only switch off jsoncrfl ???  do NOT disable all
  
  disable :protection

  PUBLIC_FOLDER = "#{SportDb::Service.root}/lib/sportdb/service/public"
  VIEWS_FOLDER  = "#{SportDb::Service.root}/lib/sportdb/service/views"

  puts "[boot] setting sportdb api public folder to: #{PUBLIC_FOLDER}"
  puts "[boot] setting sportdb api views folder to: #{VIEWS_FOLDER}" 

  set :public_folder, PUBLIC_FOLDER   # set up the static dir (with images/js/css inside)   
  set :views,         VIEWS_FOLDER    # set up the views dir

  set :static, true   # set up static file routing

  #####################
  # Models

  include SportDb::Models

  ##################
  # Helpers
  

  def path_prefix
    request.env['SCRIPT_NAME']
  end

##############################################
# Controllers / Routing / Request Handlers


get '/' do
  erb :index
end

get '/d*' do
  erb :debug
end

get '/rounds/:q' do |q|
  
  #################
  # todo/check:
  #   what to do for special case with postponed games/matches??
  #    if match postponed round end_at date also gets moved back!
  #     use a different end_at date for original end_at e.g add a new field? why? why not?
  #  -- if round out of original scope mark as postponed (e.g. spielrunde 5 - nachtrag!)

  rounds = []

  if q =~ /(\d{1,2})\.(\d{1,2})\.(\d{4})/
    t = Time.new( $3.to_i, $2.to_i, $1.to_i )
  elsif q =~ /(\d{4})\.(\d{1,2})\.(\d{1,2})/
    t = Time.new( $1.to_i, $2.to_i, $3.to_i )
  else
    t = Time.now   # no match - assume today's/current date
  end

  t_00_00 = t.beginning_of_day
  t_23_59 = t.end_of_day

  ## NB: sqlite stores time too
  #   use 00_00 and 23_59 to make sure queries work with hours too

  current_rounds = Round.where( 'start_at <= ? and end_at >= ?', t_23_59, t_00_00 )
  current_rounds.each do |r|
    rounds << { pos: r.pos,
                title: r.title,
                start_at: r.start_at.strftime('%Y/%m/%d'),
                end_at:   r.end_at.strftime('%Y/%m/%d'),
                event: { key:  r.event.key,
                         title: r.event.full_title }}
  end

  data = { rounds: rounds }
  
  json_or_jsonp( data )
end


get '/event/:key/teams' do |key|
  # NB: change en.2012_13 to en.2012/13
  event = Event.find_by_key!( key.tr('_', '/') )

  teams = []
  event.teams.each do |t|
    teams << { key: t.key, title: t.title, code: t.code }
  end

  data = { event: { key: event.key, title: event.full_title }, teams: teams }

  json_or_jsonp( data )
end


get '/event/:key/rounds' do |key|
  # NB: change en.2012_13 to en.2012/13
  event = Event.find_by_key!( key.tr('_', '/') )

  rounds = []
  event.rounds.each do |r|
    rounds << { pos: r.pos, title: r.title,
                start_at: r.start_at.strftime('%Y/%m/%d'),
                end_at:   r.end_at.strftime('%Y/%m/%d') }
  end

  data = { event: { key: event.key, title: event.full_title }, rounds: rounds }

  json_or_jsonp( data )
end


get '/event/:key/round/:pos' do |key,pos|
  # NB: change en.2012_13 to en.2012/13
  event = Event.find_by_key!( key.tr('_', '/') )

  if pos =~ /\d+/
    round = Round.find_by_event_id_and_pos!( event.id, pos )
  else  # assume last from today's date (use last/today/etc. - must be non-numeric key)
    t_23_59 = Time.now.end_of_day
    round = Round.where( event_id: event.id ).where( 'start_at <= ?', t_23_59 ).order( 'pos' ).last
    if round.nil?   # assume all rounds in the future; display first upcoming one
      round = Round.where( event_id: event.id ).order('pos').first
    end
  end

  games = []
  round.games.each do |g|
    games << { team1_key: g.team1.key, team1_title: g.team1.title, team1_code: g.team1.code,
               team2_key: g.team2.key, team2_title: g.team2.title, team2_code: g.team2.code,
               play_at: g.play_at.strftime('%Y/%m/%d'),
               score1:   g.score1,   score2:   g.score2,
               score1ot: g.score1ot, score2ot: g.score2ot,
               score1p:  g.score1p,  score2p:  g.score2p
             }
  end

  data = { event: { key: event.key, title: event.full_title },
           round: { pos: round.pos, title: round.title,
                    start_at: round.start_at.strftime('%Y/%m/%d'),
                    end_at:   round.end_at.strftime('%Y/%m/%d')
                  },
           games: games }

  json_or_jsonp( data )
end


### helper for json or jsonp response (depending on callback para)

private
def json_or_jsonp( data )
  callback = params.delete('callback')
  response = ''

  if callback
    content_type :js
    response = "#{callback}(#{data.to_json})"
  else
    content_type :json
    response = data.to_json
  end
  
  response
end

end # class Server


end #  module SportDb::Service