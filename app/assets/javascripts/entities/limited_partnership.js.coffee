# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on "click", "img[id='comma']", ->
    toggle_comma("on")
  
  $(document).on "click", "img[id='comma-grey']", ->
    toggle_comma("off")

  toggle_comma = (what) ->
    #alert("here now " + what)
    if what == "off"
      $("#comma").show()
      $("#comma-grey").hide()
      $("#entity_has_comma").val(true)
    else 
      $("#comma").hide()
      $("#comma-grey").show()
      $("#entity_has_comma").val(false)
    #is_comma = $(document).find('input.has_comma_val').val()
    #alert("Lets see " + is_comma)

  $(document).ready ->
    #alert("all is well")
    v = $("#entity_has_comma").val()
    #alert("what is " + v)
    if v == "true"
      toggle_comma("off")
    else
      toggle_comma("on")

  $(document).on "ajax:success", "a.entity-page-xhr, form.entity-page-xhr", (data, xhr, status)->
    v = $("#entity_has_comma").val()
    name = $("#entity_name").val()
    legal_ending_str = $("#entity_legal_ending").val()
    comma_str = " "
    if v == "true"
      toggle_comma("off")
      comma_str = ", "
    else
      toggle_comma("on")
    if name
      name = name.trim()
      $('#edit-title-lp').html(name+comma_str+legal_ending_str)
    if (typeof xhr) == "object" && xhr.redirect != undefined
      window.location.href = xhr.redirect+"?just_created="+xhr.just_created      
    else
      tab_ = $("#int_action").val()
      if tab_
        str_ = " / "        
        $("#int-action-lp").html(str_ + '<a href="#">'+tab_+'</a>')
      $.scrollTo(0)
      $.unblockUI()
