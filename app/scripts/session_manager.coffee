@sessionManager =

  blockNewTabs: ->
    chrome.tabs.onCreated.addListener sessionManager.blockTab

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
    chrome.storage.onChanged.addListener (changes, areaName) ->
      if changes.timeout
        sessionManager.changeResetInterval parseInt(changes.timeout.newValue)
      else if changes.tabBlocking
        sessionManager.setTabBlocking()
      else if changes.forceReOpen
        sessionManager.setBrowserReOpener()

  # !caution! this method will delete ALL cookies in the current browser session
  destroyAllCookies: ->
    chrome.cookies.getAll {}, (cookies) ->
      for cookie in cookies
        chrome.cookies.remove { name: cookie.name }

  destroyHistory: ->
    chrome.history.deleteAll ->

  executeMessage: (msg) ->
    @resetSession() if msg.reset
    @destroyAllCookies if msg.clearPersonalInfo
    @changeResetInterval(msg.resetInterval.newInterval) if msg.resetInterval
    console.log msg.console if msg.console
    @destroyHistory if msg.destroyHistory

  forceBrowserReOpen: ->
    chrome.windows.onRemoved.addListener sessionManager.reOpenBrowser

  fullscreenMode: ->
    chrome.tabs.query {}, (tabs) ->
      chrome.windows.update tabs[0].windowId, { state: "fullscreen" }

  init: ->
    sessionManager.dataListeners()
    sessionManager.setResetTimer()
    sessionManager.setTabBlocking()
    sessionManager.setBrowserReOpener()
    sessionManager.openPort()

  # defaults root page to google. Will be overridden be value of rootUrl in
  # storage if it exists
  navigateToRoot: ->
    chrome.storage.local.get { rootUrl: "http://www.google.com "}, (items) ->
      chrome.tabs.query {}, (tabs) ->
        chrome.tabs.update tabs[0].id, { url: items.rootUrl }

  # registers a message listener to receive messages from the kioskSessionAPI
  # content script API
  openPort: ->
    chrome.runtime.onConnect.addListener (port) =>
      port.onMessage.addListener (msg) =>
        @executeMessage(msg)
  
  reOpenBrowser: ->
    chrome.windows.getAll {}, (windows) ->
      if windows.length == 0
        chrome.windows.create({
          focused: true
          type: 'normal'
        }, ->
          sessionManager.resetSession()
    )

  resetSession: ->
    sessionManager.closeExtraTabs()
    # sessionManager.destroyAllCookies()
    sessionManager.navigateToRoot()
    sessionManager.fullscreenMode()
    sessionManager.destroyHistory()

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
    chrome.tabs.onCreated.removeListener sessionManager.blockTab

  unForceBrowserReOpen: ->
    chrome.windows.onRemoved.removeListener sessionManager.reOpenBrowser
