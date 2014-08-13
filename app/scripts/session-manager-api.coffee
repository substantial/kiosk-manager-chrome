@kioskSessionAPI =

  openPort: ->
    @port = chrome.runtime.connect()

  resetSession: ->
    @port.postMessage { reset: true }

  clearPersonalInfo: ->
    @port.postMessage { clearPersonalInfo: true  }

  changeResetInterval: (interval) ->
    @port.postMessage { resetInterval: { newInterval: interval } }

  tempResetInterval: (interval) ->
    port = @port
    @changeResetInterval(interval)
    chrome.runtime.onMessage.addListener (message, sender, sendResponse) ->
      if message.navigation
        port.postMessage { resetInterval: {} }
        chrome.runtime.onMessage.removeListener(this)
      sendResponse({})

kioskSessionAPI.openPort()
