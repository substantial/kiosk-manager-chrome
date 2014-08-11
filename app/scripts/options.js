(function() {
  'use strict';
  this.options = {
    restoreOptions: function() {
      chrome.storage.local.get({
        rootUrl: '',
        timeout: 60,
        whitelist: []
      }, function(items) {
        var whitelist;
        document.getElementById('rootUrl').value = items.rootUrl;
        document.getElementById('timeout').value = items.timeout;
        whitelist = items.whitelist;
        document.getElementById('whitelist').value = whitelist.join(', ');
      });
    },
    saveOptions: function() {
      var timeout, url, whitelist;
      url = document.getElementById('rootUrl').value;
      timeout = document.getElementById('timeout').value;
      whitelist = document.getElementById('whitelist').value;
      chrome.storage.local.set({
        rootUrl: url,
        timeout: timeout,
        whitelist: whitelist.split(", ")
      });
    }
  };

  document.addEventListener('DOMContentLoaded', this.options.restoreOptions);

  document.getElementById('save').addEventListener('click', this.options.saveOptions);

}).call(this);
