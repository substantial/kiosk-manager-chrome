(function() {
  'use strict';
  chrome.runtime.onInstalled.addListener(function(details) {
    return console.log('previousVersion', details.previousVersion);
  });

  this.KioskManager = {
    init: function() {
      sessionManager.setResetTimer();
    }
  };

  KioskManager.init();

}).call(this);
