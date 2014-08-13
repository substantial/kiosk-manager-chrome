(function() {
  window.kioskSessionDomApi = {
    resetSession: function() {
      return window.postMessage({
        type: "FROM_KIOSK_API",
        msg: {
          reset: true
        }
      }, "*");
    },
    clearPersonalInfo: function() {
      return window.postMessage({
        type: "FROM_KIOSK_API",
        msg: {
          clearPersonalInfo: true
        }
      }, "*");
    },
    clearHistory: function() {
      return window.postMessage({
        type: "FROM_KIOSK_API",
        msg: {
          destroyHistory: true
        }
      }, "*");
    },
    changeResetInterval: function(interval) {
      return window.postMessage({
        type: "FROM_KIOSK_API",
        msg: {
          newInterval: interval
        }
      }, "*");
    },
    tempResetInterval: function(interval) {
      return window.postMessage({
        type: "FROM_KIOSK_API",
        msg: {
          tempResetInterval: interval
        }
      }, "*");
    }
  };

}).call(this);
