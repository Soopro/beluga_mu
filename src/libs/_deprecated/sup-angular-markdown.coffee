###

Sup Angular Markdown Editor

Author : Redy Ru
Email : redy.ru@gmail.com
License : MIT
Description: A Markdown Editor project for Angularjs with pure js.

---- Usage ----
On your html create a markdown:
<div sup-angular-markdown name="sup-markdown"
 toolbar="sup-markdown-toolbar" skip-iframe="true"
 default="Default rich text here..." ng-model="yourNgModel">

###


supMarkdownEditor = ->

# ---------------- Global Variables --------------
  ver = '0.1.2'
  now = Date.now()

  # options
  $options =
    nontoolbar: false

  # property
  $property =
    name: ''
    order: 0

  # major
  $document = undefined
  $markdown = undefined
  $toolbar = undefined

  # History
  $history = []
  $history_step = null

  # Hooks
  insertLinkHook = undefined
  insertImgHook = undefined
  convertHtmltoMarkdown = undefined

  # toolbar buttons
  defaultToolbarBtns = [
    [
      'i'
      'b'
      'strike'
    ]
    [
      'hr'
      'code'
      'img'
      'a'
    ]
    [
      'ud'
      'rd'
      'convert'
    ]
  ]


  btnList = [
    {
      name: 'code'
      handler: 'insertCode'
      ico: 'code'
      status: ''
    }
    {
      name: 'i'
      handler: 'makeItalic'
      ico: 'italic'
      status: ''
    }
    {
      name: 'b'
      handler: 'makeBold'
      ico: 'bold'
      status: ''
    }
    {
      name: 'strike'
      handler: 'makeStrike'
      ico: 'strikethrough'
      status: ''
    }
    {
      name: 'hr'
      handler: 'insertHR'
      ico: 'arrows-h'
      status: ''
    }
    {
      name: 'img'
      handler: 'insertImg'
      ico: 'picture-o'
      status: ''
    }
    {
      name: 'a'
      handler: 'insertA'
      ico: 'link'
      status: ''
    }
    {
      name: 'redo'
      handler: 'reDo'
      ico: 'redo'
      status: ''
    }
    {
      name: 'undo'
      handler: 'unDo'
      ico: 'undo'
      status: ''
    }
    {
      name: 'markdown'
      handler: 'toMarkdown'
      ico: 'markdown'
      status: ''
    }
  ]



# ------------------- Event Handlers -----------------

  makeBold = (e) ->
    toggleDeco('**')

  makeItalic = (e) ->
    toggleDeco('*')

  makeStrike = (e) ->
    toggleDeco('~~')

  insertCode = (e) ->
    selected = getSelection()
    if selected.is_newline
      code = '\n```\n'
      offset = 5
    else
      code = '`'
      offset = 1
    toggleDeco(code, offset)

  insertHR = (e) ->
    line = '----'
    selected = getSelection()
    if selected.is_newline and not selected.text
      line = '\n'+line+'\n' if not selected.has_linebreak
    else
      line = '\n\n'+line+'\n\n'
    insertAtCaret(line)


  insertA = (e) ->
    if typeof insertLinkHook == 'function'
      insertLinkHook()
    else
      link = prompt('Link:', '#')
      insertAtCaret('['+link+']('+link+')') if link


  insertImg = (e) ->
    if typeof insertImgHook == 'function'
      insertImgHook()
    else
      src = prompt('Img:', 'http://')
      insertAtCaret('![]('+src+')') if src and src != 'http://'

  toMarkdown = (e) ->
    if typeof convertHtmltoMarkdown == 'function'
      convertHtmltoMarkdown()
    else
      alert('No Convert module.')

  reDo = (e) ->
    historyManager.redo()

  unDo = (e) ->
    historyManager.undo()

  record = (e) ->
    if e.type is 'keyup' and e.keyCode not in [13, 8, 46, 17, 91, 88]
      return
    historyManager.record()

# ------------------- Functions -----------------

  getSelection = ->
    scrollPos = $markdown.scrollTop
    strPos = $markdown.selectionStart or 0
    endPos = $markdown.selectionEnd or 0

    front = $markdown.value.substring(0, strPos)
    back = $markdown.value.substring(endPos, $markdown.value.length)

    front_last = front.charAt(front.length-1)
    front_break = front.charAt(front.length-2) is '\n' and front_last is '\n'
    back_first = back.charAt(0)
    back_break = back.charAt(1) is '\n' and back_first is '\n'
    is_newline = front_last is '\n' and back_first is '\n'
    has_linebreak = front_break and back_break

    selected = $markdown.value.substring(strPos, endPos) or ''
    return {
      scroll: scrollPos,
      start: strPos,
      end: endPos,
      text: selected,
      is_newline: is_newline,
      has_linebreak: has_linebreak
    }

  insertSelection = (text, selected, sel_offset_start, sel_offset_end)->
    selectionOffset=
      start: sel_offset_start or 0
      end: sel_offset_end or sel_offset_start or 0

    scrollPos = selected.scroll
    strPos = selected.start
    endPos = selected.end

    front = $markdown.value.substring(0, strPos)
    back = $markdown.value.substring(endPos, $markdown.value.length)

    $markdown.value = front+text+back

    endPos = selected.start+text.length

    $markdown.selectionStart = strPos+selectionOffset.start
    $markdown.selectionEnd = endPos-selectionOffset.end
    $markdown.focus()
    $markdown.scrollTop = scrollPos
    return {
      scroll: scrollPos,
      start: strPos,
      end: endPos,
      text: selected
    }


  isHTMLElement = (o) ->
    if not o
      return false
    is_obj = o and typeof o == 'object' and o != null
    is_obj_type = o.nodeType is 1 and typeof o.nodeName is 'string'
    result =  is_obj and is_obj_type
    return result


  match_deco = (text, deco)->
    if deco is "*"
      is_bold = text.match(/^(\*\*)+[^\*]*(\*\*)+$/ig)
      return not is_bold and text.indexOf(deco) is 0
    else
      return text.indexOf(deco) is 0

  toggleDeco = (deco, sel_offset)->
    selected = getSelection()
    text = selected.text

    if not match_deco(text, deco)
      text = deco+text+deco
    else
      start = deco.length
      end = text.length-deco.length
      text = text.substring(start, end)

    insertSelection(text, selected, sel_offset)
    return

  insertAtCaret = (text)->
    scrollPos = $markdown.scrollTop
    strPos = $markdown.selectionStart or 0

    front = $markdown.value.substring(0, strPos)
    back = $markdown.value.substring(strPos, $markdown.value.length)
    $markdown.value = front+text+back
    strPos = strPos + text.length

    $markdown.selectionStart = strPos
    $markdown.selectionEnd = strPos
    $markdown.focus()

    $markdown.scrollTop = scrollPos
    return

  historyManager =
    redo: ->
      if $history_step < $history.length - 1
        $history_step++
        $markdown.value = $history[$history_step]

    undo: ->
      if $history_step > 0
        $history_step--
        $markdown.value = $history[$history_step]

    record: ->
      if $markdown.value == $history[$history_step or 0]
        return

      if typeof($history_step) isnt 'number'
        $history_step = 0
      else
        $history_step++

      if $history.length >= $history_step+1
        $history.length = $history_step+1

      if $history_step >= $options.history-1
        $history_step = $options.history-1
        $history.shift()
      $history.push $markdown.value


# -------------------------- Utils ------------------------

  log = (args) ->
    console.log '---------------------------'
    console.log 'SAMd Editor Log: (' + $property.name + ')'
    for i of arguments
      if arguments.hasOwnProperty(i)
        console.log arguments[i]
    console.log '---------------------------'

  error = (args) ->
    console.log '---------------------------'
    console.log 'SAMd Editor Error: (' + $property.name + ')'
    for i of arguments
      if arguments.hasOwnProperty(i)
        console.error arguments[i]
    console.log '---------------------------'


  assertParam = (param, type, failback) ->
    if not failback
      failback = ''
    if not type
      type = 'string'
    result = if typeof param is type then param else failback
    return result

  isJsonString = (str) ->
    try
      JSON.parse str
    catch e
      return false
    return true

  mergeJSON = (source1, source2) ->

    ###
    # Properties from the Souce1 object will be copied to Source2 Object.
    # Note: This method will return a new merged object, Source1 and Source2
    # original values will not be replaced.
    #
    ###

    output = Object.create(source2)
    # Copying Source2 to a new Object
    for attrname of source1
      if output.hasOwnProperty(attrname)
        if source1[attrname] != null and
        source1[attrname].constructor == Object
          ###
          # Recursive call if the property is an object,
          # Iterate the object and set all properties of the inner object.
          ###
          output[attrname] = zrd3.utils.mergeJSON(source1[attrname],
                                                  output[attrname])
      else
        #else copy the property from source1
        output[attrname] = source1[attrname]
    return output


  createToolbarBtns = (toolbar) ->
    attr_tbs = toolbar.getAttribute('toolbar-btns')
    if not attr_tbs
      return toolbar
    tbs = attr_tbs.replace(/'/g, '"')
    if isJsonString(tbs)
      tbs = JSON.parse(tbs)
    if typeof tbs isnt 'object' or not tbs.length or tbs.length is 0
      tbs = defaultToolbarBtns
    i = 0
    while i < tbs.length
      group = document.createElement('div')
      j = 0
      while j < tbs[i].length
        val = tbs[i][j]
        if toolbar.querySelector('.btn-' + val)
          j++
          continue
        btn = document.createElement('button')
        btn.className = 'btn btn-' + val
        ico = undefined
        for k of btnList
          if btnList[k].name == val
            ico = btnList[k].ico
            break
        if ico
          btn.innerHTML = '<i class="ico-' + ico + '"></i>'
        else
          btn.innerHTML = val.toUpperCase()
        group.appendChild btn
        j++
      if group.childNodes.length > 1
        group.className = 'btn-group'
        toolbar.appendChild group
      else
        group = null
      i++
    return toolbar


  evtManager =
    register: (target, handler, event) ->
      if typeof event != 'string'
        event = 'click'
      if typeof target == 'object'
          target.addEventListener event, handler
      return
    remove: (target, handler, event) ->
      if typeof event != 'string'
        event = 'click'
      if typeof target == 'object'
        if typeof handler == 'function'
          target.removeEventListener event, handler
      return


# ------------------ executes -------------------

  execInsertImage = (imgObj) ->
    if not imgObj
      return
    src = assertParam(imgObj.src)
    alt = assertParam(imgObj.title)
    href = assertParam(imgObj.href)

    seleted = getSelection()
    if seleted.text
      md_text = '!['+alt+']('+src+' "'+alt+'")'
    else
      md_text = '!['+alt+']('+src+' "'+alt+'")'

    if href
      md_text = '['+md_text+']('+href+' "'+alt+'")'

    insertAtCaret(md_text)


  execInsertLink = (linkObj) ->
    if not linkObj
      return
    href = assertParam(linkObj.href)
    seleted = getSelection()
    if seleted.text
      md_text = '['+seleted.text+']('+href+')'
    else
      md_text = '['+href+']('+href+')'

    insertAtCaret(md_text)

# ------------------ Construction ----------------

  init_markdown = (markdown, toolbar, opt) ->
    #Setup base options and attributes
    load_options(opt)
    $document = document

    if typeof markdown == 'string' and markdown != ''
      $markdown = $document.querySelector('[name='+ markdown + ']')
    else if markdown and markdown.tagName is 'TEXTAREA'
      $markdown = markdown
    if not $markdown
      return error 'Init markdown failed !!'
    if not $options.nontoolbar
      if typeof toolbar == 'string' and toolbar != ''
        $toolbar = $document.querySelector('[name=' + toolbar + ']')
      else if isHTMLElement(toolbar)
        $toolbar = toolbar

      if not $toolbar
        return error 'Init toolbar failed !!'

    #Setup options and property
    if $toolbar
      $toolbar = createToolbarBtns($toolbar)

    $property.order = parseInt($markdown.getAttribute('order')) or 0
    $property.name = $markdown.getAttribute('name') or now

    # listener for record history
    for evt in ['focus', 'keyup', 'change', 'cut', 'paste']
      $markdown.addEventListener(evt, record)

    set_toolbar()
    console.log '---- supAngularMarkdown inited ----'
    console.log 'version:', ver
    return

  destroy_markdown = ->
    unset_toolbar()
    console.log '---- supAngularMarkdown destroyed ----'
    return

  set_toolbar = ->
    if not $toolbar
      return
    i = 0
    while i < btnList.length
      obj = $toolbar.querySelector('.btn-' + btnList[i].name)
      if obj
        evtManager.register obj, eval(btnList[i].handler)
      i++

  unset_toolbar = ->
    if not $toolbar
      return
    i = 0
    while i < btnList.length
      obj = $toolbar.querySelector('.btn-' + btnList[i].name)
      if obj
        evtManager.remove obj, eval(btnList[i].handler)
      i++

  load_options = (opt) ->
    if typeof opt is 'string'
      opt = opt.replace(/'/g, '"')
      try
        opt = JSON.parse(opt)
      catch e
        opt = {}

    if not opt or typeof opt isnt 'object'
      opt = {}

    $options = mergeJSON(opt, $options)
    return $options or {}

  get_options = ->
    return $options

  set_insert_link_hook = (func) ->
    if typeof func == 'function'
      insertLinkHook = func
    else
      return false

  set_insert_img_hook = (func) ->
    if typeof func == 'function'
      insertImgHook = func
    else
      return false

  set_html_to_markdown = (func) ->
    if typeof func == 'function'
      convertHtmltoMarkdown = func
    else
      return false

  get_property = ->
    $property

  get_name = ->
    $property.name

  get_order = ->
    $property.order

  methods =
    version: ver
    init: init_markdown
    destroy: destroy_markdown
    property: get_property
    name: get_name
    order: get_order
    options: get_options
    hooks:
      insert_link: set_insert_link_hook
      insert_image: set_insert_img_hook
      html_to_markdown: set_html_to_markdown
    insertImage: execInsertImage
    insertLink: execInsertLink

  return methods


# --------------------------------------------
# Sup Angular Markdown Editor Angular Module
# --------------------------------------------

angular.module 'supAngularMarkdown', []

.directive "supAngularMarkdown", [
  '$rootScope'
  '$timeout'
  (
    $rootScope
    $timeout
  ) ->
    restrict: 'EA',
    require: '?ngModel',
    scope:
      toolbar: '@'
      options: '@'
      skipIframe: '@'
      output:'='
      default: '@'
    link: (scope, element, attrs, ngModel) ->
      return unless ngModel # do nothing if no ng-model
      return unless scope.output isnt undefined
      return unless typeof(window.marked) is 'function'
      return unless typeof(window.toMarkdown) is 'function'

      toMarkdown = window.toMarkdown

      marked = window.marked
      marked.setOptions
        headerPrefix: 'sup-markdown-id-'

      parseMarkdown = (md_text)->
        if not md_text or typeof(md_text) isnt 'string'
          return ''
        output = marked(md_text)
        output = output.replace(/id=['"]sup\-markdown\-id\-.*?['"]/ig, '')
        # remove the id created by `marked`.
        return output

      markdown = new supMarkdownEditor
      markdown_name = 'sup-markdown'
      markdown_element = element[0]

      if attrs.name
        markdown_name = attrs.name

      if not scope.toolbar
        toolbar = markdown_name + '-toolbar'

      # parse options
      try
        options = scope.options.replace(/'/g, '"')
        options = JSON.parse(options)
      catch e
        options = {}

      root = $rootScope
      if not scope.skipIframe and window.parent \
      and parent.document isnt document
        root = parent.angular.element(parent.document).scope()
        toolbar = parent.document.querySelector('[name='+toolbar+']')

      $timeout ->
        markdown.init markdown_element, toolbar, options
      , 0

      # hooks and events
      markdown.hooks.insert_link ->
        root.$emit 'editor.insert_link', markdown

      markdown.hooks.insert_image ->
        root.$emit 'editor.insert_image', markdown

      markdown.hooks.html_to_markdown ->
        if typeof toMarkdown is 'function'
          md_text = toMarkdown(ngModel.$viewValue)
          ngModel.$setViewValue md_text
          ngModel.$render()
        else
          console.error 'toMarkdown is required.'

      # Dispatch event editor complete
      $rootScope.$emit 'editor.complete', markdown
      if root isnt $rootScope
        # for current rootScope and parent window scope both.
        # if in children window, rootScope is different with root.
        root.$emit 'editor.complete', markdown

      scope.$on '$destroy', ->
        markdown.destroy()

      render = ngModel.$render
      ngModel.$render = ->
        if typeof(ngModel.$viewValue) is 'string'
          scope.output = parseMarkdown(ngModel.$viewValue)
        else
          scope.output = ''
        render()

      element.on 'blur focus input', (e)->
        if e.target
          ngModel.$setViewValue e.target.value
          ngModel.$render()
        e.stopPropagation()
        return
]


.directive "supAngularMarkdownRender", [
  '$timeout'
  (
    $timeout
  ) ->
    restrict: 'EA',
    require: '?ngModel',
    scope:
      default: '@'
    link: (scope, element, attrs, ngModel) ->
      return unless ngModel # do nothing if no ng-model
      dirty = false
      ngModel.$render = ->
        if not ngModel.$viewValue and not dirty
          element.html scope.default
        else
          element.html ngModel.$viewValue or ""
        dirty = true

]