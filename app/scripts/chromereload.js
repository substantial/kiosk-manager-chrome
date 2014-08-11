(function() {
  'use strict';

  /*
  Reload client for Chrome Apps & Extensions.
  The reload client has a compatibility with livereload.
  WARNING: only supports reload command.
   */
  var LIVERELOAD_HOST, LIVERELOAD_PORT, connection;

  LIVERELOAD_HOST = 'localhost:';

  LIVERELOAD_PORT = 35729;

  connection = new WebSocket('ws://' + LIVERELOAD_HOST + LIVERELOAD_PORT + '/livereload');

  connection.onerror = function(e) {
    return console.log('reload connection got error' + JSON.stringify(e));
  };

  connection.onmessage = function(e) {
    var data;
    if (e.data) {
      data = JSON.parse(e.data);
      if (data && data.command === 'reload') {
        return chrome.runtime.reload();
      }
    }
  };

}).call(this);
