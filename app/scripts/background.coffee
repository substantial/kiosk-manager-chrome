'use strict';

chrome.runtime.onInstalled.addListener (details) ->
    console.log('previousVersion', details.previousVersion)

@KioskManager =
	init: ->
		sessionManager.setResetTimer()
		return

KioskManager.init()