// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
document.addEventListener('DOMContentLoaded', function() {
  var Elm = require( '../elm/Main' );
  Elm.Main.embed( document.getElementById( 'main' ) );
})
