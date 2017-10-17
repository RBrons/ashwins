# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on "click", "img[id='comma']", ->
    toggle_comma("on")
  
  $(document).on "click", "img[id='comma-grey']", ->
    toggle_comma("off")

  toggle_comma = (what) ->
    if what == "off"
      $("#comma").show()
      $("#comma-grey").hide()
      $("#entity_has_comma").val(true)
    else
      $("#comma").hide()
      $("#comma-grey").show()
      $("#entity_has_comma").val(false)

  $(document).ready ->
    v = $("#entity_has_comma").val()
    if v == "true"
      toggle_comma("off")
    else
      toggle_comma("on")

  $(document).on "ajax:success", "a.entity-page-xhr, form.entity-page-xhr", (data, xhr, status) ->
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
      $('#edit-title-pship').html(name + comma_str + legal_ending_str)
    if (typeof xhr) == "object" && xhr.redirect != undefined
      window.location.href = xhr.redirect + "?just_created=" + xhr.just_created
    else
      tab_ = $("#int_action").val()
      if tab_ == 'Partners List'
        $('.partnership_icp_list').text('Partners List View')
      else
        $('.partnership_icp_list').text('')
        
      if tab_
        str_ = " / "
        $("#int-action-pship").html(str_ + '<a href="#">' + tab_ + '</a>')
      $.scrollTo(0)
      $.unblockUI()
      