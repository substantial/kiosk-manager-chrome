'use strict'

chrome.runtime.onInstalled.addListener (details) ->
  console.log('previousVersion', details.previousVersion)

@KioskManager =

  init: ->
    sessionManager.init()
    whitelistUrls.init()

KioskManager.init()