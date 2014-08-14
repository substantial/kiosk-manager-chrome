'use strict'

chrome.runtime.onInstalled.addListener (details) ->
  console.log('previousVersion', details.previousVersion)

@KioskManager =

  init: ->
    sessionManager.init()
    whitelistUrls.init()
    scriptInjector.init()
    @navigationListener()

  navigationListener: ->
    chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
      if changeInfo.url
        chrome.tabs.sendMessage tabId, { navigation: changeInfo.url }

KioskManager.init()