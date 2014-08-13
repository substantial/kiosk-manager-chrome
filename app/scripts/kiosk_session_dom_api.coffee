window.kioskSessionDomApi =
  resetSession: ->
    window.postMessage { type: "FROM_KIOSK_API", msg: { reset: true } }, "*"

  clearPersonalInfo: ->
    window.postMessage { type: "FROM_KIOSK_API", msg: clearPersonalInfo: true }, "*"

  clearHistory: ->
    window.postMessage { type: "FROM_KIOSK_API", msg: { destroyHistory: true } }, "*"

  changeResetInterval: (interval) ->
    window.postMessage { type: "FROM_KIOSK_API", msg: { newInterval: interval } }, "*"

  tempResetInterval: (interval) ->
    window.postMessage { type: "FROM_KIOSK_API", msg: { tempResetInterval: interval } }, "*"
