////////////////////////////////////
// football.db api wrapper

define( function(require) {
 'use strict';

  require( 'utils' );
  
  var Api = {};

Api.create = function( opts )
{

  var defaults = {
                baseUrl: 'http://footballdb.herokuapp.com/api/v1'
              };
  var settings;


  function init( opts )
  {
    settings = _.extend( {}, defaults, opts );
    
    debug( 'baseUrl: ' + settings.baseUrl );
  }


  function fetch( path, onsuccess )
  {
    var url = settings.baseUrl + path + '?callback=?';
    $.getJSON( url, onsuccess );
  }

  function fetchRounds( event, onsuccess )
  {
    fetch( '/event/' + event + '/rounds', onsuccess );
  }

  function fetchRound( event, round, onsuccess )
  {
    fetch( '/event/' + event + '/round/' + round, onsuccess );
  }

  function fetchRoundsToday( onsuccess )
  {
    // fetch( '/rounds/2013.6.30', onsuccess );
    fetch( '/rounds/today', onsuccess );
  }

  // call "c'tor/constructor"
  init( opts );

  // return/export public api
  return {
     fetchRound:        fetchRound,
     fetchRounds:       fetchRounds,
     fetchRoundsToday:  fetchRoundsToday
  }
} // end fn Api.create

  return Api;

}); // end define