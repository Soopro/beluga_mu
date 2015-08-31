// Generated by CoffeeScript 1.9.3

/*
Sup Analytics

Author : Redy Ru
Email : redy.ru@gmail.com
License : 2014 MIT
Version 1.0.0

---- Usage ----
	load on front page.
 */

(function() {
  var supAnalytics;

  supAnalytics = (function() {
    'use strict';
    var api, sa, xmlhttp;
    if (!window['sa']) {
      return;
    }
    sa = void 0;
    xmlhttp = void 0;
    sa = window['sa'];
    if (!sa.id || !sa.api || !sa.app) {
      return;
    }
    api = sa.api + '/app/' + sa.app + '/visit/' + sa.id;
    if (window.XMLHttpRequest) {
      xmlhttp = new XMLHttpRequest;
    } else {
      xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
    }
    xmlhttp.open('GET', api, true);
    return xmlhttp.send();
  })();

}).call(this);
