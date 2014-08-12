@sessionManager = 

	blockNewTabs: ->
		chrome.tabs.onCreated.addListener sessionManager.blockTab

	blockTab: (tab) ->
		chrome.tabs.remove tab.id

	closeExtraTabs: ->
		tabIds = []
		chrome.tabs.query {}, (tabs) ->
			for tab in tabs
				tabIds.push tab.id
			chrome.tabs.remove tabIds.slice(1)

	dataListeners: ->
		chrome.storage.onChanged.addListener (changes, areaName) ->
			if changes.timeout
				chrome.idle.setDetectionInterval parseInt(changes.timeout.newValue)
			else if changes.tabBlocking
				sessionManager.setTabBlocking()

	# !caution! this method will delete ALL cookies in the current browser session
	destroyAllCookies: ->
		chrome.cookies.getAll {}, (cookies) ->
			for cookie in cookies
				chrome.cookies.remove { name: cookie.name }

	fullscreenMode: ->
		chrome.tabs.query {}, (tabs) ->
			chrome.windows.update tabs[0].windowId, { state: "fullscreen" }

	init: ->
		sessionManager.dataListeners()
		sessionManager.setResetTimer()

	# defaults root page to google. Will be overridden be value of rootUrl in storage
	# if it exists
	navigateToRoot: ->
		chrome.storage.local.get { rootUrl: "http://www.google.com "}, (items) ->
			chrome.tabs.query {}, (tabs) ->
				chrome.tabs.update tabs[0].id, { url: items.rootUrl }

	resetSession: ->
		sessionManager.closeExtraTabs()
		# sessionManager.destroyAllCookies()
		sessionManager.navigateToRoot()
		sessionManager.fullscreenMode()

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