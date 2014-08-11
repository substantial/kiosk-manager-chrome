@whitelistUrls =

	init: ->
		whitelistUrls.retreiveStore()
		whitelistUrls.dataListeners()
		whitelistUrls.blockUrls()
	
	blockUrls: ->
		chrome.webRequest.onBeforeRequest.addListener (details) =>
			if details.type == "main_frame" && !@isWhitelisted details.url
				return { redirectUrl: @rootUrl }
			return
		, { urls: ["http://*/*", "https://*/*"] }
		, ["blocking"]

	dataListeners: ->
		chrome.storage.onChanged.addListener (changes, areaName) =>
			if areaName == "local"
				@whitelist = changes.whitelist.newValue if changes.whitelist
				@rootUrl = changes.rootUrl.newValue if changes.rootUrl

	isWhitelisted: (url) ->
		for domain in @whitelist
			re = new RegExp('.*' + domain + '.*')
			return true if re.test url
		false

	retreiveStore: ->
		chrome.storage.local.get ["whitelist", "rootUrl"], (items) =>
			@whitelist = items.whitelist
			@rootUrl = items.rootUrl
