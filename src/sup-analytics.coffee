###
Sup Analytics

Author : Redy Ru
Email : redy.ru@gmail.com
License : 2014 MIT
Version 1.0.0

---- Usage ----
	load on front page.
###

supAnalytics = do ->
  'use strict'
  if !window['sa']
    return
  sa = undefined
  xmlhttp = undefined
  sa = window['sa']
  console.log sa
  if not sa.id or not sa.api or not sa.app
    return
  api = sa.api + '/app/' + sa.app + '/visit/'+sa.id
  if window.XMLHttpRequest
    # code for IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp = new XMLHttpRequest
  else
    # code for IE6, IE5
    xmlhttp = new ActiveXObject('Microsoft.XMLHTTP')
  xmlhttp.open 'GET', api, true
  xmlhttp.send()
  console.log api