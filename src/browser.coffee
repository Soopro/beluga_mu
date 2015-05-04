# -------------------------------
# Browser Detector
# -------------------------------
is_exports = typeof exports isnt "undefined" and exports isnt null
root = if is_exports then exports else this

unless root.sup
  root.sup = {}
  
mobile_list = [
  {pattern:/Android/i, name:'Android', alias:'android'}
  {pattern:/webOS/i, name:'webOS', alias:'webos'}
  {pattern:/iPhone/i, name:'iPhone', alias:'iphone'}
  {pattern:/iPad/i, name:'iPad', alias:'ipad'}
  {pattern:/iPod/i, name:'iPod', alias:'ipod'}
  {pattern:/BlackBerry/i, name:'BlackBerry', alias:'blackberry'}
  {pattern:/Windows Phone/i, name:'WindowsPhone', alias:'wp'}
]  
  
mobile = do ->
  for m in mobile_list
    if navigator.userAgent.match(m.pattern)
      return m
  return null
  
browser = do ->
  ua = navigator.userAgent
  tem = undefined
  M = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i)
  if not M
    M = []

  if /trident/i.test(M[1])
    tem = /\brv[ :]+(\d+)/g.exec(ua) or []
    return "IE " + (tem[1] or "")
  if M[1] is "Chrome"
    tem = ua.match(/\bOPR\/(\d+)/)
    return "Opera " + tem[1]  if tem?
  
  if M[2]
    M = [ M[1],M[2] ] 
  else 
    M = [ navigator.appName, navigator.appVersion, "-?" ]
  
  M.splice 1, 1, tem[1]  if (tem = ua.match(/version\/(\d+)/i))?
  M.join " "
  
  browser = 
    alias: M[0]
    ver: M[1]
    mobile: mobile

  return browser

modern_browsers = ['Chrome','Opera','Safari','Firefox','MSIE']
is_modern_browser = true

unless browser.alias in modern_browsers
  is_modern_browser = false

if browser.alias is 'MSIE' and parseInt(browser.ver) < 10
  is_modern_browser = false

if navigator.userAgent.indexOf('Mobile') > -1
  is_modern_browser = true

unless is_modern_browser
  window.location.href = sup.server.web+'/old_browser'

root.sup.browser = browser

console.log 'Detect browser: ', root.sup.browser