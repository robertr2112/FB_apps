# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready(function(){
  $('.dropdown .dropdown').each(function(){
    var $self = $(this);
    var handle = $self.children('[data-toggle="dropdown"]');
    $(handle).click(function(){
      var submenu = $self.children('.dropdown-menu');
      $(submenu).toggle();
      return false;
    });
  });
});
