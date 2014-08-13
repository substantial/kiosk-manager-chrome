@kioskSessionCSApi =

  openPort: ->
    @port = chrome.runtime.connect()

  resetSession: ->
    @port.postMessage { reset: true }

  clearPersonalInfo: ->
    @port.postMessage { clearPersonalInfo: true  }

  clearHistory: ->
    @port.postMessage { destroyHistory: true }

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

  insertDomApi: ->
    script = document.createElement 'script'
    script.src = chrome.extension.getURL('scripts/session_manager_dom_api.js')
    (document.head || document.documentElement).appendChild(script)

  listenToDom: ->
    window.addEventListener 'message', (event) =>
      return unless event.source == window
      if event.data.type && event.data.type == "FROM_KIOSK_API"
        # because tempResetInterval uses a chrome.* API it is handled separately
        if event.data.msg.tempResetInterval
          @tempResetInterval(event.data.msg.tempResetInterval)
        else
          @port.postMessage event.data.msg

kioskSessionApi.openPort()
kioskSessionApi.insertDomApi()
kioskSessionApi.listenToDom()
