%%%%%%%%%%%%%%%%%
% NB: after generation add/patch w/ macro
%
%  replace
%     http://footballdb.herokuapp.com/api/v1/event/en.2012_13/round/2
%  with
%     <%= url( '/' ) %>event/en.2012_13/round/2....  twice
%%%%%%%%%

## Usage

In your hypertext (HTML) document using a plain vanilla cross-domain JavaScript
request (using the JSONP technique):

    <script>
      function handleGames( json ) {
         // Do something with the returned data
      }
    </script>
    
    <script src="http://footballdb.herokuapp.com/api/event/en.2012_13/round/2?callback=handleGames"></script>


Or using the jQuery library using the [`getJSON` function](http://api.jquery.com/jQuery.getJSON):

    $.getJSON('http://footballdb.herokuapp.com/api/event/en.2012_13/round/2?callback=?', function(json) {
      // Do something with the returned data
    });

Note: Add the `callback=?` query parameter to tell jQuery to use a cross-domain JSONP request.

That's it.
