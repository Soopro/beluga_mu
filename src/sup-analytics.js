/*
Sup Analytics

Author : Redy Ru
Email : redy.ru@gmail.com
License : 2014 MIT
Version 1.0.0

---- Usage ----
	load on front page.
*/

(function supAnalytics() {
  'use strict';
  
  if(!window['sa']){
      return;
  }
  var sa, xmlhttp;
  
  sa = window['sa']
  if(!sa.id || !sa.api){
    return;
  }
  var api=sa.api+'/ws/'+sa.id+'/visit';

  if (window.XMLHttpRequest) {
      // code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp = new XMLHttpRequest();
  } else {
      // code for IE6, IE5
      xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
  }

  xmlhttp.open("GET", api, true);
  xmlhttp.send();
})();