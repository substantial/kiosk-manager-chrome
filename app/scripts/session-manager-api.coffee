@chromeSessionAPI =

  openPort: ->
    @port = chrome.runtime.connect()

  resetSession: ->
    @port.postMessage { reset: true }

  clearPersonalInfo: ->
    @port.postMessage { clearPersonalInfo: true  }

chromeSessionAPI.openPort()
chromeSessionAPI.DOMListener()
