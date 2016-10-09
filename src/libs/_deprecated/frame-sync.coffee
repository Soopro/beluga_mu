# --------------------------------
# Frame Sync
# 
# Description: Use js to send information to parent window.
# Author : Redy Ru
# Email : redy.ru@gmail.com
# License : 2016 MIT
# Version 1.0.0
# Usage: 
#    just add the js.
# 
# --------------------------------

is_exports = typeof exports isnt "undefined" and exports isnt null
root = if is_exports then exports else this

html = document.documentElement
delay = html.getAttribute('frame-sync-delay') or 300
  
syncHanlder = (e) ->
  if root.parent == root
    return
  timer = setInterval ->
    root.parent.postMessage
      height: html.offsetHeight
      width: html.offsetWidth
    , '*'
  , delay

document.addEventListener 'DOMContentLoaded', syncHanlder