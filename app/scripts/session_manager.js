(function() {
  this.sessionManager = {
    closeExtraTabs: function() {
      var tabIds;
      tabIds = [];
      chrome.tabs.query({}, function(tabs) {
        var tab, _i, _len;
        for (_i = 0, _len = tabs.length; _i < _len; _i++) {
          tab = tabs[_i];
          tabIds.push(tab.id);
        }
        chrome.tabs.remove(tabIds.slice(1));
      });
    },
    dataListeners: function() {
      chrome.storage.onChanged.addListener(function(changes, areaName) {
        if (areaName === "local" && changes.timeout) {
          chrome.idle.setDetectionInterval(parseInt(changes.timeout.newValue));
        }
      });
    },
    destroyAllCookies: function() {
      chrome.cookies.getAll({}, function(cookies) {
        var cookie, _i, _len;
        for (_i = 0, _len = cookies.length; _i < _len; _i++) {
          cookie = cookies[_i];
          chrome.cookies.remove({
            name: cookie.name
          });
        }
      });
    },
    init: function() {
      sessionManager.dataListeners();
      sessionManager.setResetTimer();
    },
    navigateToRoot: function() {
      chrome.storage.local.get({
        rootUrl: "http://www.google.com "
      }, function(items) {
        chrome.tabs.query({
          active: true
        }, function(tabs) {
          chrome.tabs.update(tabs[0].id, {
            url: items.rootUrl
          });
        });
      });
    },
    resetSession: function() {
      sessionManager.closeExtraTabs();
      sessionManager.navigateToRoot();
    },
    setResetTimer: function() {
      return chrome.storage.local.get({
        timeout: 60
      }, function(items) {
        chrome.idle.setDetectionInterval(parseInt(items.timeout));
        chrome.idle.onStateChanged.addListener(function(newState) {
          if (newState !== "active") {
            resetSession();
          }
        });
      });
    }
  };

}).call(this);
