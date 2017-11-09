# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  $(document).ready ->
    $('#bc_t_color').colorpicker()
      .on 'changeColor', (event) ->
        $('.preview_color').css 'color', event.color.toHex()
    
    $('#bc_bg_color').colorpicker()
      .on 'changeColor', (event) ->
        $('.preview_color').css 'background-color', event.color.toHex()

