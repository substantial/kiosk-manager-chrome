@sessionManager =

  blockNewTabs: ->
    chrome.tabs.onCreated.addListener @blockTab

  blockTab: (tab) ->
    # check to see if tab is being opened from Chrome extension page so as not
    # to block the extension options page
    if tab.openerTabId
      chrome.tabs.get tab.openerTabId, (parentTab) ->
        unless parentTab.url == "chrome://extensions/" || tab.index == 0
          chrome.tabs.remove tab.id
    else
      chrome.tabs.remove tab.id unless tab.index == 0

  changeResetInterval: (interval) ->
    if interval
      chrome.idle.setDetectionInterval parseInt(interval)
    else
      chrome.storage.local.get "timeout", (items) ->
        chrome.idle.setDetectionInterval parseInt(items.timeout)
  
  closeExtraTabs: ->
    tabIds = []
    chrome.tabs.query {}, (tabs) ->
      for tab in tabs
        tabIds.push tab.id
      chrome.tabs.remove tabIds.slice(1)

  # Makes sure all relevant variables are updated if any changes are made on
  # the options page
  dataListeners: ->
    chrome.storage.onChanged.addListener (changes, areaName) =>
      if changes.timeout
        @changeResetInterval parseInt(changes.timeout.newValue)
      else if changes.tabBlocking
        @setTabBlocking()
      else if changes.forceReOpen
        @setBrowserReOpener()

  # !caution! this method will clear virtually all browsing data from Chrome.
  clearBrowsingData: ->
    chrome.browsingData.remove {}, {
      "appcache": true
      "cache": true
      "cookies": true
      "downloads": true
      "fileSystems": true
      "formData": true
      "history": true
      "indexedDB": true
      "localStorage": true
      "serverBoundCertificates": true
      "pluginData": true
      "passwords": true
      "webSQL": true
    }

  executeMessage: (msg) ->
    @resetSession() if msg.reset
    @clearBrowsingData() if msg.clearPersonalInfo
    @changeResetInterval(msg.resetInterval.newInterval) if msg.resetInterval
    console.log msg.console if msg.console

  forceBrowserReOpen: ->
    chrome.windows.onRemoved.addListener @reOpenBrowser

  fullscreenMode: ->
    chrome.windows.getLastFocused (window) ->
      chrome.windows.update window.id, { state: "fullscreen" }

  init: ->
    @dataListeners()
    @setResetTimer()
    @setTabBlocking()
    @setBrowserReOpener()
    @openPort()

  # defaults root page to google. Will be overridden be value of rootUrl in
  # storage if it exists
  navigateToRoot: ->
    chrome.storage.local.get { rootUrl: "http://www.google.com", preventHomeReset: false }, (items) ->
      chrome.tabs.query {}, (tabs) ->
        unless tabs[0].url == items.rootUrl || items.preventHomeReset
          chrome.tabs.update tabs[0].id, { url: items.rootUrl }

  # registers a message listener to receive messages from the kioskSessionAPI
  # content script API
  openPort: ->
    chrome.runtime.onConnect.addListener (port) =>
      port.onMessage.addListener (msg) =>
        @executeMessage(msg)
  
  reOpenBrowser: ->
    chrome.windows.getAll {}, (windows) =>
      if windows.length == 0
        chrome.windows.create({
          focused: true
          type: 'normal'
        }, =>
          @sessionManager.resetSession()
    )

  resetSession: ->
    console.log("Session is resetting!!")
    @closeExtraTabs()
    @navigateToRoot()
    @clearBrowsingData()
    @fullscreenMode()

  setBrowserReOpener: ->
    chrome.storage.local.get { forceReOpen: true }, (items) =>
      if items.forceReOpen then @forceBrowserReOpen() else @unForceBrowserReOpen()

  setResetTimer: ->
    chrome.storage.local.get { timeout: 60 }, (items) =>
      chrome.idle.setDetectionInterval parseInt(items.timeout)
      chrome.idle.onStateChanged.addListener (newState) =>
        @resetSession() unless newState == "active"

  setTabBlocking: () ->
    chrome.storage.local.get { tabBlocking: true }, (items) =>
      if items.tabBlocking then @blockNewTabs() else @unBlockNewTabs()

  unBlockNewTabs: ->
    chrome.tabs.onCreated.removeListener @blockTab

  unForceBrowserReOpen: ->
    chrome.windows.onRemoved.removeListener @reOpenBrowser
