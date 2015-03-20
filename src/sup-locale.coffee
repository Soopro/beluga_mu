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

root.sup.setLocale = (loc) ->
  locale = null
  loc = loc.replace('-','_')

  for k,v of sup.localizedDict
    if k.toLowerCase() is loc.toLowerCase()
      locale = k
      break
  
  if locale and root.sup.localizedDict[locale]
    locale_dict = root.sup.localizedDict[locale]
  else
    locale_dict = null
  
  root.sup.localizedText = if locale_dict then locale_dict else {}
  root.sup.locale = locale
  return root.sup.locale


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
    supLocale.init()
]

.service "supLocale", [
  '$rootScope'
  '$cookieStore'
  (
    $rootScope
    $cookieStore
  ) ->
    default_locale = 'en_US'
    self = @
    
    @init = (loc)->
      if loc
        default_locale = loc
      userLang = navigator.language or navigator.userLanguage
      userLocale = userLang.replace('-','_')
      try
        cookieLocale = $cookieStore.get 'current_locale'
      catch e
        cookieLocale = null
    
      currLocale = if cookieLocale then cookieLocale else userLocale
      self.set currLocale
      $rootScope._ = sup.translate

    @set = (loc) ->
      locale = sup.setLocale loc
      locale = locale or default_locale
      $rootScope.locale = locale
      $rootScope.lang = locale.split('_')[0] or 'en'
      $cookieStore.put 'current_locale', locale
      
    @get = ->
      try
        cookieLocale = $cookieStore.get 'current_locale'
      catch e
        cookieLocale = null
      return cookieLocale

    return  @
]