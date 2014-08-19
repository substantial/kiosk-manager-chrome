'use strict'

@options =

  restoreOptions: ->
    chrome.storage.local.get({
      rootUrl: ''
      timeout: 60
      whitelist: []
      tabBlocking: true
      forceReOpen: true
      script: null
      }, (items) ->
      document.getElementById('rootUrl').value = items.rootUrl
      document.getElementById('timeout').value = items.timeout
      whitelist = items.whitelist
      document.getElementById('whitelist').value = whitelist.join(', ')
      document.getElementById('tab-blocking').checked = items.tabBlocking
      document.getElementById('force-reopen').checked = items.forceReOpen
      document.getElementById('inject-script').value = items.script
    )

  saveOptions: (event) ->
    event.preventDefault()
    url = document.getElementById('rootUrl').value
    
    #add root url's domain to whitelist to prevent redirect loop
    options.whitelistRoot(url)

    timeout = document.getElementById('timeout').value
    whitelist = document.getElementById('whitelist').value
    tabBlocking = document.getElementById('tab-blocking').checked
    forceReOpen = document.getElementById('force-reopen').checked
    script = document.getElementById('inject-script').value

    chrome.storage.local.set
      rootUrl: url
      timeout: timeout
      whitelist: whitelist.split(", ")
      tabBlocking: tabBlocking
      forceReopen: forceReOpen
      script: script
    , ->
      el = document.getElementById('messages')
      if chrome.runtime.lastError
        el.classList.add('error')
        el.innerHTML = 'An error occured attempting to save your settings.'
      else
        el.classList.add('success')
        el.innerHTML = 'Your settings were updated successfully.'

  whitelistRoot: (url) ->
    rootDomain = url.split(/:\/\//)[1]
    whitelist = document.getElementById('whitelist')
    unless whitelist.value.indexOf(rootDomain) != -1
      whitelist.value += ", " + rootDomain

document.addEventListener 'DOMContentLoaded', @options.restoreOptions
document.getElementById('save').addEventListener 'click', @options.saveOptions
    