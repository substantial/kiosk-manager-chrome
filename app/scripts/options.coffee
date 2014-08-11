'use strict';

var options =
	restoreOptions: ->
		chrome.storage.local.get
			rootUrl: ''
			timeout: 60
			whitelist: []
			keyboard: false
		, (items) ->
			document.get.
