(function() {
  'use strict';
  chrome.runtime.onInstalled.addListener(function(details) {
    return console.log('previousVersion', details.previousVersion);
  });

  this.KioskManager = {
    init: function() {
      sessionManager.init();
      whitelistUrls.init();
    }
  };

  KioskManager.init();

}).call(this);
