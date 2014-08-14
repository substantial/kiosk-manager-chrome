# as currently implemented this is extremely dangerous since it blindly
# executes any JS code entered into the extension options field, which could
# be accessed maliciously

@scriptInjector =

  init: ->
    @listenForNav()
    @dataListeners()

  dataListeners: ->
    chrome.storage.onChanged.addListener (changes, areaName) =>
      if areaName == 'local' && changes.script
        chrome.tabs.onUpdated.removeListener @pageScript
        @listenForNav()
  
  listenForNav: ->
    chrome.storage.local.get 'script', (items) =>
      if items.script
        @script = items.script
        chrome.tabs.onUpdated.addListener @pageScript

  pageScript: (tabId, changeInfo, tab) ->
    if changeInfo.url || changeInfo.status == "loading"
      chrome.tabs.executeScript tabId, { code: scriptInjector.script }
