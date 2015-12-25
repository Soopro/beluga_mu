###
 supFrameHeight

 Author : Redy Ru
 Email : redy.ru@gmail.com
 License : 2014 MIT
 Version 1.0.0

 ---- Usage ----
 This script is for send message to parent window if current page is in a frame.
 It's work great with angularjs directive 'invisible-iframe'

  # invisible-iframe
  .directive "invisibleIframe", ->
      restrict: "A"
      link: (scope, element, attr) ->
        frameHeightHandler = (e) ->
          if typeof e.data is "number"
            element[0].style.height = e.data + 20 + "px"
          else
            element[0].style.height = "auto"
          return
        window.addEventListener "message", frameHeightHandler

        scope.$on "$destroy", ->
          window.removeEventListener "message", frameHeightHandler

###

root = window

unless root.sup
  root.sup = {}

init = ->
  console.log "*** Start post frame height. ***"
  root.sup.postFrameHeight = ->
    window.parent.postMessage(document.body.offsetHeight,'*');

  if window.parent and window.parent.postMessage
    interval = setInterval ->
      root.sup.postFrameHeight()
      return
    , 100

  window.addEventListener "DOMContentLoaded", root.sup.postFrameHeight
  window.addEventListener "resize", root.sup.postFrameHeight
  window.addEventListener "load", root.sup.postFrameHeight

if window.self isnt window.top and window.self isnt window.parent
  init()
