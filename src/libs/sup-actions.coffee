###
 supActions

 Author : Redy Ru
 Email : redy.ru@gmail.com
 License : 2014 MIT
 Version 1.0.0

###
angular.module 'supActions', []

# dragable
.directive "draggable", [
  "$document"
  ($document) ->
    return (scope, element) ->
      
      # Prevent default dragging of selected content
      #        event.preventDefault();
      mousemove = (event) ->
        y = event.screenY - startY
        x = event.screenX - startX
        element.css
          top: y + "px"
          left: x + "px"

        return
      mouseup = ->
        $document.off "mousemove", mousemove
        $document.off "mouseup", mouseup
        return
      startX = 0
      startY = 0
      x = 200
      y = 60
      element.css
        top: y + "px"
        left: x + "px"
        cursor: "pointer"

      element.on "mousedown", (event) ->
        startX = event.screenX - x
        startY = event.screenY - y
        $document.on "mousemove", mousemove
        $document.on "mouseup", mouseup
]

# focus
.directive "focus", [
  '$timeout'
  (
    $timeout
  ) ->
    restrict: "EA"
    scope:
      trigger: "="

    link: (scope, element) ->
      scope.$watch "trigger", (value) ->
        if value
        
          #console.log('trigger',value);
          $timeout (->
            element[0].focus()
            scope.trigger = false
            return
          ), 500
]


# click outside

# Orginal: This angular module base on AdamMettro's angular-click-outside
# https://github.com/IamAdamJowett/angular-click-outside

.directive "clickOutside", [
  '$document'
  (
    $document
  ) ->
    restrict: "A"
    scope:
      clickOutside: "&"

    link: (scope, elem, attr) ->

      if attr.outsideIfNot isnt undefined
        classList = attr.outsideIfNot.replace(", ", ",").split(",") 
      else 
        classList = []
      
      classList.push attr.id if attr.id isnt undefined

      $document.on "click", (e) ->
        if not e.target
          return

        element = e.target
        while element
          id = element.id
          classNames = element.className

          if id isnt undefined
            i = 0
            while i < classList.length
              if id.indexOf(classList[i]) > -1 or
              classNames.indexOf(classList[i]) > -1
                return   
              i++

          element = element.parentNode
        
        scope.$eval scope.clickOutside

]