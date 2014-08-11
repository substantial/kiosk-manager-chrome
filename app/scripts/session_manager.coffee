@sessionManager = 

	closeExtraTabs: ->
		tabIds = []
		chrome.tabs.query {}, (tabs) ->
			for tab in tabs
				tabIds.push tab.id
			chrome.tabs.remove tabIds.slice(1)
			return
		return

	destroyAllCookies: ->
		chrome.cookies.getAll {}, (cookies) ->
			for cookie in cookies
				chrome.cookies.remove { name: cookie.name }
			return
		return

	navigateToRoot: ->
		chrome.storage.local.get { rootUrl: "http://www.google.com "}, (items) ->
			chrome.tabs.query { active: true }, (tabs) ->
				chrome.tabs.update tabs[0].id, { url: items.rootUrl }
				return
			return
		return

	resetSession: ->
		sessionManager.closeExtraTabs()
		# sessionManager.destroyAllCookies()
		sessionManager.navigateToRoot()
		return

	setResetTimer: ->
		chrome.storage.local.get { timeout: 60 }, (items) ->
			chrome.idle.setDetectionInterval parseInt(items.timeout)
			chrome.idle.onStateChanged.addListener (newState) ->
				resetSession() unless newState == "active"
				return
			return