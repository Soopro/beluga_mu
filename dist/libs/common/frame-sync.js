// Generated by CoffeeScript 1.10.0
(function() {
  var delay, html, is_exports, root, syncHanlder;

  is_exports = typeof exports !== "undefined" && exports !== null;

  root = is_exports ? exports : this;

  html = document.documentElement;

  delay = html.getAttribute('frame-sync-delay') || 300;

  syncHanlder = function(e) {
    var timer;
    if (root.parent === root) {
      return;
    }
    return timer = setInterval(function() {
      return root.parent.postMessage({
        height: html.offsetHeight,
        width: html.offsetWidth
      }, '*');
    }, delay);
  };

  document.addEventListener('DOMContentLoaded', syncHanlder);

}).call(this);