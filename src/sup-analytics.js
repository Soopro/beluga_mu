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
  var API_HOST = 'http://api.soopro.com/'
  if(!window['sa']){
      return;
  }

  var xmlhttp;
  var api=window['sa_api']+'ws/'+window['sa']+'/visit';

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