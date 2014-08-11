(function() {
  this.whitelistUrls = {
    init: function() {
      whitelistUrls.retreiveStore();
      whitelistUrls.dataListeners();
      whitelistUrls.blockUrls();
    },
    blockUrls: function() {
      chrome.webRequest.onBeforeRequest.addListener((function(_this) {
        return function(details) {
          if (details.type === "main_frame" && !_this.isWhitelisted(details.url)) {
            return {
              redirectUrl: _this.rootUrl
            };
          }
        };
      })(this), {
        urls: ["http://*/*", "https://*/*"]
      }, ["blocking"]);
    },
    dataListeners: function() {
      chrome.storage.onChanged.addListener((function(_this) {
        return function(changes, areaName) {
          if (areaName === "local") {
            if (changes.whitelist) {
              _this.whitelist = changes.whitelist.newValue;
            }
            if (changes.rootUrl) {
              _this.rootUrl = changes.rootUrl.newValue;
            }
          }
        };
      })(this));
    },
    isWhitelisted: function(url) {
      var domain, re, _i, _len, _ref;
      _ref = this.whitelist;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        domain = _ref[_i];
        re = new RegExp('.*' + domain + '.*');
        if (re.test(domain)) {
          return true;
        }
      }
      return false;
    },
    retreiveStore: function() {
      chrome.storage.local.get(["whitelist", "rootUrl"], (function(_this) {
        return function(items) {
          _this.whitelist = items.whitelist;
          _this.rootUrl = items.rootUrl;
        };
      })(this));
    }
  };

}).call(this);
