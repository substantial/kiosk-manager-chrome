@chromeSessionAPI =

  openPort: ->
    @port = chrome.runtime.connect()

  resetSession: ->
    @port.postMessage { reset: true }

  clearPersonalInfo: ->
    @port.postMessage { clearPersonalInfo: true  }

  changeResetInterval: (interval) ->
    @port.postMessage { moreTime: { newInterval: interval } }

chromeSessionAPI.openPort()
