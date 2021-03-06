# -------------------------------
# Browser Detector
# -------------------------------
is_exports = typeof exports isnt "undefined" and exports isnt null
root = if is_exports then exports else this

unless root.sup
  root.sup = {}

version = "0.1.2"

mobile_list = [
  {pattern:/Android/i, name:'Android', alias:'android'}
  {pattern:/webOS/i, name:'webOS', alias:'webos'}
  {pattern:/iPhone/i, name:'iPhone', alias:'iphone'}
  {pattern:/iPad/i, name:'iPad', alias:'ipad'}
  {pattern:/iPod/i, name:'iPod', alias:'ipod'}
  {pattern:/BlackBerry/i, name:'BlackBerry', alias:'blackberry'}
  {pattern:/Windows Phone/i, name:'WindowsPhone', alias:'wp'}
]

modern_browsers = {
  'chrome': 40,
  'opera': 30,
  'safari': 8,
  'firefox': 40,
  'msie': 10
}

black_list =
  android: ['UCBrowser', 'Opera', 'SougouMobile', 'DolphineBrowser',
            'MQQBrowser', 'Baidu']
  ios: ['SougouMobile', 'OS 6_']

mobile = do ->
  for m in mobile_list
    if navigator.userAgent.match(m.pattern)
      return {name: m.name, alias: m.alias}
  if navigator.userAgent.indexOf('Mobile') > -1
    return {name: '', alias: '' }
  return null

browser = do ->
  ua = navigator.userAgent
  tem = undefined
  M = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i)
  if not M
    M = []

  name = null
  ver = null

  if /trident/i.test(M[1])
    tem = /\brv[ :]+(\d+)/g.exec(ua) or []
    name = "MSIE"
    ver = (tem[1] or "")

  if M[1] is "Chrome"
    tem = ua.match(/\bOPR\/(\d+)/)
    name = "Opera" if tem?
    ver = tem[1] if tem?

  if not name and not ver
    if M[2]
      M = [ M[1], M[2] ]
    else
      M = [ navigator.appName, navigator.appVersion, "-?" ]

    M.splice 1, 1, tem[1]  if (tem = ua.match(/version\/(\d+)/i))?

    name = M[0]
    ver = M[1]

  _browser =
    alias: if typeof(name) is 'string' then name.toLowerCase() else null
    name: name
    ver: ver
    mobile: mobile

  return _browser

check_version = (browser)->
  return modern_browsers[browser.alias] > parseInt(browser.ver)

# test if modern browser
is_modern_browser = true

if check_version(browser)
  is_modern_browser = false

if browser.mobile
  is_modern_browser = true

# except for mobile browsers
if browser.mobile
  # ios 6
  if browser.alias is 'safari' and parseInt(browser.ver) < 7
    is_modern_browser = false

  # others
  _black_list = black_list[browser.mobile.alias] or []
  for blackbrowser in _black_list
    if navigator.userAgent.indexOf(blackbrowser) > -1
      is_modern_browser = false
      break

browser.is_modern_browser = is_modern_browser

# console.log 'Detect browser: ', browser

# make it global, pass to other frameworks.
root.sup.browser = browser


# get root <html>
html = document.documentElement
return if not html

if typeof(html.hasAttribute) isnt 'function'
  html.hasAttribute = (attrName)->
    return typeof(html[attrName]) isnt 'undefined'



# templates ----------------------->

head_template = (assets_path)->
  '<title>Old Browser</title>'+
  '<link href="'+assets_path+'browser-detector.css" rel="stylesheet">'

body_template = (assets_path)->
  '<div id="wrapper">'+
  ' <div id="logo">'+
  '   <img src="'+assets_path+'browser_detector_logo.png" alt="Soopro"/>'+
  ' </div>'+
  ' <div class="content">'+
  '   <p>'+
  '     Your browser is too old.<br>'+
  '     We recommend you choose more reliable web browser following:'+
  '   </p>'+
  '   <p>您的浏览器老掉牙了，希望您能紧跟时代立刻升级。'+
  '   推荐您使用这些浏览器：</p>'+
  ' </div>'+
  ' <div class="browsers">'+
  '   <div class="browser">'+
  '     <a href="http://www.firefox.com" target="_blank">'+
  '       <img src="'+assets_path+'browser_firefox.png" '+
  '        alt="Firefox"/>'+
  '     </a>'+
  '   </div>'+
  '   <div class="browser">'+
  '     <a href="http://www.chrome.com" target="_blank">'+
  '       <img src="'+assets_path+'browser_chrome.png" '+
  '        alt="Chrome"/>'+
  '     </a>'+
  '   </div>'+
  '   <div class="browser">'+
  '     <a href="http://support.apple.com/downloads/#safari" target="_blank">'+
  '       <img src="'+assets_path+'browser_safari.png" '+
  '        alt="Safari"/>'+
  '     </a>'+
  '   </div>'+
  '   <div class="browser">'+
  '     <a href="http://www.opera.com/" target="_blank">'+
  '       <img src="'+assets_path+'browser_opera.png" '+
  '        alt="Opera"/>'+
  '     </a>'+
  '   </div>'+
  ' </div>'+
  ' <div class="copyright">'+
  '   <small>&copy; Soopro Co.,ltd.</small>'+
  ' </div>'+
  '</div>'

# rendering
rendering = ->
  # process test
  if html.hasAttribute('modern-browser-tester')

    for attr in html.attributes
      html.removeAttribute(attr)

    while html.firstChild
      html.removeChild(html.firstChild)

    head = document.createElement("HEAD")
    head.innerHTML = '<title>Browser Tester</title>'
    html.appendChild(head)

    body = document.createElement("BODY")

    modern = if browser.is_modern_browser then 'Modern' else 'Old'
    mobile_name = if browser.mobile then browser.mobile.name else '-'

    body.innerHTML = ''+
    '<h1>'+browser.name+' '+browser.ver+' '+mobile_name+' '+modern+'</h1>'+
    '<p>appName: '+navigator.appName+'</p>'+
    '<p>appVersion: '+navigator.appVersion+'</p>'+
    '<small>&lt; '+navigator.userAgent+' &gt;</small>'

    html.appendChild(body)
    return

  # process pass
  if not html.hasAttribute('modern-browser')
    return

  # process not modern
  if not is_modern_browser
    assets_src = html.getAttribute('modern-browser')

    if assets_src in ['0', 'false', 'null', false, 0, null, undefined]
      return
    else if typeof(assets_src) isnt 'string'
      assets_src = ''
    else if assets_src in ['true', '1']
      assets_src = ''

    try
      if assets_src in ['.', 'self']
        assets_path = ''
      else
        assets_path = assets_src
    catch e
      assets_path = ''

    remove_attr_list = []
    for attr in html.attributes
      remove_attr_list.push(attr.name)
    for attr in remove_attr_list
      html.removeAttribute(attr)

    while html.firstChild
      html.removeChild(html.firstChild)

    head = document.createElement("HEAD")
    head.innerHTML = head_template(assets_path)
    html.appendChild(head)

    body = document.createElement("BODY")
    body.innerHTML = body_template(assets_path)
    html.appendChild(body)

    return


# run ----------------------------->
try
  rendering()
catch e
  detector_url = html.getAttribute('modern-browser')
  if not detector_url \
  or typeof detector_url isnt 'string' \
  or detector_url.indexOf('http') != 0
    detector_url = ''

  if detector_url.slice(-1) == '/'
    detector_url = detector_url.slice(0, -1)

  window.location.href = detector_url + '/default.html'
