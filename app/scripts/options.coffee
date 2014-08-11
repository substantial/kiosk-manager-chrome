'use strict';

@options =

	restoreOptions: ->
		chrome.storage.local.get({
			rootUrl: ''
			timeout: 60
			whitelist: []
			}, (items) ->
				document.getElementById('rootUrl').value = items.rootUrl
				document.getElementById('timeout').value = items.timeout
				whitelist = items.whitelist
				document.getElementById('whitelist').value = whitelist.join(', ')
				return
		)
		return

	saveOptions: ->
		url = document.getElementById('rootUrl').value
		timeout = document.getElementById('timeout').value
		whitelist = document.getElementById('whitelist').value
		chrome.storage.local.set({
			rootUrl: url
			timeout: timeout
			whitelist: whitelist.split(", ")
		})
		return

document.addEventListener 'DOMContentLoaded', @options.restoreOptions
document.getElementById('save').addEventListener 'click', @options.saveOptions
		