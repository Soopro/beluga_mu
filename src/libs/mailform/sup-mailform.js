/* -------------------------------- */
/* sup MailForm
/* version:  0.1.0
/* -------------------------------- */

(function(window) {
  "use strict";

  function init() {
    if (!inited){
      process_forms();
    }
  }
  function process_forms(){
    var mailform_list = document.querySelectorAll('[sup-mailform]');
    if (!mailform_list || mailform_list.length <= 0){
      return;
    }
    for (var i=0; i < mailform_list.length; i++){
      mailform_list[i].addEventListener('submit', process_fields);
    }
  }
  function is_unchecked(field){
    if (field.type == 'radio' && !field.checked) {
      return true;
    }
    if (field.type == 'checkbox' && !field.checked) {
      return true;
    }
  }
  function process_fields(e) {
    var mailform = e.target;
    if (!mailform.querySelectorAll) {
      return;
    }
    var fields = mailform.querySelectorAll('input, select, textarea');
    var maildata = [];
    var subject = ':)';
    
    for (var i = 0; i < fields.length; i++){
      var field = fields[i];
      var title = '';
      if (field.title) {
        title = field.title;
      }else if(field.name && field.name != 'subject'){
        var _name = field.name;
        title = _name.charAt(0).toUpperCase() + _name.slice(1);
      }
      if (field.name == 'subject'){
        subject = field.value || subject;
      }
      if (is_unchecked(field)){
        continue;
      }
      if (title){
        maildata.push({'title': field.title, 'value': field.value || ''});
      }
    }
    var mail_content = process_mail(maildata);
    var mail_action = mailform.action.split("?")[0];
    mail_action = mail_action+'?subject='+subject;
    mail_action = mail_action+'&body='+encodeURIComponent(mail_content);
    window.location.href = mail_action;
    e.preventDefault();
    return false;
  }
  function process_mail(maildata) {
    var mail_content = '';
    for (var i = 0; i < maildata.length; i++){
      var data = maildata[i];
      mail_content = mail_content+data.title+": "+data.value+'\n';
    }
    return mail_content;
  }

  /* Document.redy
  /* -------------------------------- */
  if (document.readyState === "complete" || document.readyState === "loaded") {
    init();
  } else {
    var inited = false;
    function init_handler(e) {
      if (inited){
        return;
      }
      switch (e.type) {
        case 'DOMContentLoaded':
          document.removeEventListener('DOMContentLoaded', init_handler);
          break;
        case 'load':
          window.removeEventListener('load', init_handler);
          break;
      }
      init();
      inited = true;
    }
    document.addEventListener('DOMContentLoaded', init_handler);
    window.addEventListener("load", init_handler);
  }
}(window));