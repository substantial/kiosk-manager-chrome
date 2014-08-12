'use strict';

@options =

	restoreOptions: ->
		chrome.storage.local.get({
			rootUrl: ''
			timeout: 60
			whitelist: []
			tabBlocking: true
			}, (items) ->
				document.getElementById('rootUrl').value = items.rootUrl
				document.getElementById('timeout').value = items.timeout
				whitelist = items.whitelist
				document.getElementById('whitelist').value = whitelist.join(', ')
				document.getElementById('tab-blocking').checked = items.tabBlocking
		)

	saveOptions: ->
		url = document.getElementById('rootUrl').value
		timeout = document.getElementById('timeout').value
		whitelist = document.getElementById('whitelist').value
		tabBlocking = document.getElementById('tab-blocking').checked
		chrome.storage.local.set({
			rootUrl: url
			timeout: timeout
			whitelist: whitelist.split(", ")
			tabBlocking: tabBlocking
		})

document.addEventListener 'DOMContentLoaded', @options.restoreOptions
document.getElementById('save').addEventListener 'click', @options.saveOptions
		