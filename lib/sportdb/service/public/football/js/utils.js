define( function(require) {

//////////////////////////////////////////
// debug utils

function puts( msg ) {
  if( window.console && window.console.log )
      window.console.log( msg );
}

function pp( obj ) {
  if( window.console && window.console.dir )
      window.console.dir( obj );
}

function debug( msg ) {
  puts( '[debug] '+msg );
}


////////////////////////////
// date utils

function cmp_date( date1, date2 ) {
   if( date1.getDate()     === date2.getDate()  &&
       date1.getMonth()    === date2.getMonth()  &&
       date1.getFullYear() === date2.getFullYear() )
     return 0;
   else
     return 1;  // todo: return -1 or 1 if greater or smaller
}


var month_names = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December' ];

var day_names = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday' ];

function fmt_date( date ) {

  return day_names[ date.getDay()] +
          ", " +
         month_names[ date.getMonth()] +
          " " +
         date.getDate() +
          " " +
         date.getFullYear();
}

//////////////////////////////////////////
// exports (global functions)

   debug( 'export utils globals (that is, attach functions to global obj)' );

   // NB: assumes this is global object e.g. window
   this.puts     = puts;
   this.pp       = pp;
   this.debug    = debug;
   this.cmp_date = cmp_date;
   this.fmt_date = fmt_date;

}); // end define