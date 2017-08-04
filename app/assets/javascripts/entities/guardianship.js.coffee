# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on "ajax:success", "a.entity-page-xhr, form.entity-page-xhr", (data, xhr, status)->
    str = "#entity_guardianship_"
    fname = $(str + "first_name").val()
    lname = $(str + "last_name").val()
    if fname 
      $('#edit-title-g').html("In re " + fname + " " + lname + ", AIP")
    if (typeof xhr) == "object" && xhr.redirect != undefined
      window.location.href = xhr.redirect+"?just_created="+xhr.just_created      
    else
      tab_ = $("#int_action").val()
      if tab_
        str_ = " / "        
        $("#int-action-gdship").html(str_ + '<a href="#">'+tab_+'</a>')
      $.scrollTo(0)
      $.unblockUI()