////////////////////
// wrapper for jquery plugin

define( function(require) {
  // 'use strict';

               require( 'utils' );
  var Widget = require( 'football/widget' );
  // todo: check - use Football.Api or Football.Service  why? why not??


  function registerFn( $ ) {

    debug( 'register jquery fn football' );

    function setupFootballWidget( el, opts ) {
      var w = Widget.create( el, opts );

      // todo: use a common name control,ctrl,widget or similar for all?
      $(el).data( 'widget', w );

      return el;
    }

    $.fn.football = function( opts ) {
        return this.each( function( index, el ) {
          debug( 'before setupFootballWidget['+ index +']' );
          setupFootballWidget( el, opts );
          debug( 'after setupFootballWidget['+ index +']' );
        });
    };
  }

  registerFn( jQuery );

}); // end define
