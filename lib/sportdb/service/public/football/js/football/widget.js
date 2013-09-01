define( function(require) {
 'use strict';

            require( 'utils' );
  var Api = require( 'football/api' );
  // todo: check - use Football.Api or Football.Service  why? why not??

  var eventTpl        = require( 'text!../../templates/event.html' ),
      roundsLongTpl   = require( 'text!../../templates/rounds-long.html' ),
      roundsShortTpl  = require( 'text!../../templates/rounds-short.html' ),
      gamesTpl        = require( 'text!../../templates/games.html' ),
      roundsTodayTpl  = require( 'text!../../templates/rounds-today.html');

  var renderEventDef       = _.template( eventTpl ),
      renderRoundsLongDef  = _.template( roundsLongTpl ),
      renderRoundsShortDef = _.template( roundsShortTpl ),
      renderGamesDef       = _.template( gamesTpl ),
      renderRoundsTodayDef = _.template( roundsTodayTpl );

  var Widget = {};

Widget.create = function( id, opts ) {

  var $el,
      $event,    // used for event header 
      $rounds,   // used for rounds
      $games;    // used for round details (matches/games)

  var renderEvent,    // compiled underscore templates - nb: a compiled template is just a js function
      renderRoundsLong,
      renderRoundsShort,
      renderGames,
      renderRoundsToday;

  var api;

  var defaults = {
                   tplId: null,
                   showRounds: true
                 };
  var settings;


  function init( id, opts )
  {
     settings = _.extend( {}, defaults, opts );

     debug( 'tplId: '      + settings.tplId );
     debug( 'event: '      + settings.event );
     debug( 'showRounds: ' + settings.showRounds );

     debug( 'api: '   + (settings.api !== undefined) );

     if( settings.api === undefined || settings.api === null )
        api = Api.create();
     else
        api = settings.api;


     if( settings.tplId === null )  // use builtin template
        renderGames = renderGamesDef;
     else                           // use user specified/supplied template
        renderGames = _.template( $( settings.tplId ).html() );


     renderEvent       = renderEventDef;
     renderRoundsShort = renderRoundsShortDef;
     renderRoundsLong  = renderRoundsLongDef;
     renderRoundsToday = renderRoundsTodayDef;

     $el  = $( id );
     $el.addClass( 'football-widget' );  // for styling add always .football-widget class

     $event  = $( '<div />' ).addClass( 'event' );
     $rounds = $( '<div />' ).addClass( 'rounds' );
     $games  = $( '<div />' ).addClass( 'games' );
    
     $el.append( $event, $rounds, $games );

    if( settings.event === undefined || settings.event === null ) {
       // no event specified; display todays rounds
       updateRoundsToday();
    }
    else {
     if( settings.showRounds ) {
        updateRounds();
        updateRound( '1' );
     }
     else {
        updateRound( 'today' );
     }
    }
  }


  function update() { }


  function updateRoundsToday()
  {
    debug( 'update rounds for today' );
    api.fetchRoundsToday( function( data ) {
         var snippet;

         if( data.rounds.length === 0 )
            snippet = "<p>No rounds scheduled today!</p>";
         else 
            snippet = renderRoundsToday( { rounds: data.rounds } );

         $rounds.html( snippet );
    });
  }

  function updateRounds()
  {
    debug( 'update rounds' );

    api.fetchRounds( settings.event, function( data ) {
    
      var snippet;
      
      if( data.rounds.length >= 16 )
        snippet = renderRoundsShort( { rounds: data.rounds } );
      else
        snippet = renderRoundsLong( { rounds: data.rounds } );

      $rounds.html( snippet );

      // add click funs - assumes links with data-round='3' etc.
      // - todo/check: is there a better way to add click handlers in templates?
      $rounds.find( 'a' ).click( function() {
        debug( 'click update round' );
        var $link = $(this);
        var round = $link.data( 'round' );
         debug( 'data-round:' + round );
         updateRound( round );
         return false;
      });

    }); 
  }

  function updateRound( round )
  {
    debug( 'update round: ' + round );

    api.fetchRound( settings.event, round, function( data ) {
    
      var snippet = renderGames( { games: data.games } );
      $games.html( snippet );

      var snippet2 = renderEvent( { event: data.event, round: data.round } );
      $event.html( snippet2 );

    }); 
  }  // fn update

  // call "c'tor/constructor"
  init( id, opts );

  // return/export public api
  return {
     update: update
  }
} // end fn Widget.create

  return Widget;

}); // end define