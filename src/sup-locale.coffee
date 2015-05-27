# -------------------------------
# sup Localized
# -------------------------------

is_exports = typeof exports isnt "undefined" and exports isnt null
root = if is_exports then exports else this

unless root.sup
  root.sup = {}

# make it global, easy load localize by other js files.
sup.localizedDict = {}

localizedText = {}
locale = null
CASE_SENSITIVE = false


low = (str)->
  if not CASE_SENSITIVE
    return str.toLowerCase()
  return str

load = (loc_text_list)->
  if not (loc_text_list instanceof Array)
    return {}
  loc_text_dict = {}
  for text in loc_text_list
    if text.msgid and text.msgstr
      loc_text_dict[low(text.msgid)] = text.msgstr
  return loc_text_dict

setLocale = (loc) ->
  locale = null
  loc = loc.replace('-','_')

  for k,v of sup.localizedDict
    if k.toLowerCase() is loc.toLowerCase()
      locale = k
      break
  
  if locale and sup.localizedDict[locale]
    locale_dict = sup.localizedDict[locale]
  else
    locale_dict = null
  
  localizedText = load(locale_dict)
  locale = locale
  return locale

    
translate = (text) ->
  if typeof text isnt 'string'
    return text

  trans = localizedText[low(text)]
  if not trans
    trans = text
  
  args=[]
  for arg in arguments
    args.push arg

  for arg in args[1..]
    arg = '' if arg is undefined
    trans = trans.replace("%s", arg)

  return trans
  

    
angular.module 'supLocale', ['ngCookies']

.run [
  'supLocale'
  (
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
    
    @init = (loc, case_sensitive)->
      CASE_SENSITIVE = Boolean(case_sensitive)
      
      if loc
        default_locale = loc
      
      userLang = navigator.language or navigator.userLanguage
      userLocale = userLang.replace('-','_')
      try
        cookieLocale = $cookieStore.get('current_locale')
      catch e
        cookieLocale = null
    
      currLocale = if cookieLocale then cookieLocale else userLocale
      self.set(currLocale)
      $rootScope._ = angular.translate = translate
    
    @translate = (args)->
      return translate.apply(this, arguments)
    
    @set = (loc) ->
      locale = setLocale(loc)
      locale = locale or default_locale
      $rootScope.locale = locale
      $rootScope.lang = locale.split('_')[0] or 'en'
      $cookieStore.put('current_locale', locale)
      
    @get = ->
      try
        cookieLocale = $cookieStore.get 'current_locale'
      catch e
        cookieLocale = null
      return cookieLocale
    
    @match = (lang1, lang2)->
      lang1 = lang1.replace('-','_')
      lang2 = lang2.replace('-','_')
      return lang1.toLowerCase() == lang2.toLowerCase()
    
    return  @
]