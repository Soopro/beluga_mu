# -------------------------------
# sup Localized
# -------------------------------
is_exports = typeof exports isnt "undefined" and exports isnt null
root = if is_exports then exports else this

unless root.sup
  root.sup = {}

root.sup.locale = null
root.sup.localizedDict = {}
root.sup.localizedText = {}

root.sup.setLocale = (lang) ->
  _locale = null
  for k,v of sup.localizedDict
    if k.toLowerCase() is lang.toLowerCase()
      _locale = k
      break
  
  if root.sup.localizedDict and _locale
    locale_dict =  root.sup.localizedDict[_locale]
  else
    locale_dict = null
  
  root.sup.localizedText = if locale_dict then locale_dict else {}
  root.sup.locale = _locale
  return root.sup.locale
  # result = {}
  # for text in locale_dict
  #   key = text['msgid']
  #   result[key] = text['msgstr']
  # result
  # root.sup.localizedText = if result then result else {}


root.sup.translate = (text) ->
  if typeof text isnt 'string'
    return text
  
  trans = text
  for t in root.sup.localizedText
    if t.msgid is text
      trans = t.msgstr 
      break
  
  args=[]
  for arg in arguments
    args.push arg
  args = args[1..]  
  for arg in args
    if arg
      trans = trans.replace("%s", arg)

  return trans
  

    
angular.module 'supLocale', ['ngCookies']

.run [
  '$rootScope'
  '$cookieStore'
  'supLocale'
  (
    $rootScope
    $cookieStore
    supLocale
  ) ->
    userLang = navigator.language or navigator.userLanguage
    userLang = userLang.replace('-','_')
    try
      cookieLang = $cookieStore.get 'current_language'
    catch e
      cookieLang = null
    
    currLang = if cookieLang then cookieLang else userLang
    supLocale.set currLang
    $rootScope._ = sup.translate
]

.service "supLocale", [
  '$rootScope'
  '$cookieStore'
  (
    $rootScope
    $cookieStore
  ) ->
    set: (lang) ->
      locale = sup.setLocale lang
      $rootScope.locale = locale
      $cookieStore.put 'current_language', locale
      
    get: ->
      try
        cookieLang = $cookieStore.get 'current_language'
      catch e
        cookieLang = null
      return cookieLang
]