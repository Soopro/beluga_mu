var imgUrl, lineLink, descContent,shareTitle, appid;
if(window.addEventListener){

  window.addEventListener('load', function() {
    var metaList = document.querySelectorAll('meta');
    for (var i= 0; i<metaList.length; i++){
      if (metaList[i].name == 'description'){
          descContent = metaList[i].content;
      }
      if (metaList[i].name == 'thumbnail'){
          imgUrl = metaList[i].content;
      }
    }
    if (imgUrl==undefined){
      var imgElement = document.querySelector('img');
      if(imgElement){
         imgUrl = imgElement.src;
      }
    }
  	lineLink = location.href;
    var titleElement = document.querySelector('title');
  	shareTitle = titleElement.text;
  	appid = '';
  });

  function shareFriend() {
  	WeixinJSBridge.invoke(
      'sendAppMessage',
      {
      	"appid": appid,
      	"img_url": imgUrl,
      	"img_width": "",
      	"img_height": "",
      	"link": lineLink,
      	"desc": descContent,
      	"title": shareTitle
    	}, 
      function(res) {
    	//_report('send_msg', res.err_msg);
      }
    );
  };

  function shareTimeline() {
    WeixinJSBridge.invoke(
      'shareTimeline',
      {
        "img_url": imgUrl,
        "img_width": "",
        "img_height": "",
        "link": lineLink,
        "desc": descContent,
        "title": shareTitle
      }, 
      function(res) {
      //_report('timeline', res.err_msg);
      }
    );
  };

  function shareWeibo() {
    WeixinJSBridge.invoke(
      'shareWeibo',
      {
        "content": descContent,
        "url": lineLink,
      }, 
      function(res) {
      //_report('weibo', res.err_msg);
      }
    );
  };

  document.addEventListener(
    'WeixinJSBridgeReady', 
    function onBridgeReady() {
      WeixinJSBridge.on(
        'menu:share:appmessage', 
        function(argv){
          shareFriend();
        }
      );    
      WeixinJSBridge.on(
        'menu:share:timeline', 
        function(argv){
          shareTimeline();
        }
      );
      WeixinJSBridge.on(
        'menu:share:weibo',
        function(argv){
          shareWeibo();
        }
      );
    }, 
    false
  );
  
};