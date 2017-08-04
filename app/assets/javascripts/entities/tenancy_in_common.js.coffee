# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "click", "div.entity-object-action", ->
  val = $(this).text()
  id  = $(this).parent().attr("data-id")
  $("input[name$='entity_tenancy_in_common[property_id]']").val(id)
  $("input[name$='entity_tenancy_in_common[name]']").val(val)
  $(document).find("div#ResourceFormProperties").modal("hide")

$(document).on "ajax:success", "a.entity-page-xhr, form.entity-page-xhr, form.new_property_xhr", (data, xhr, status)->
    #console.log(data)    
    name = $("#entity_tenancy_in_common_property_id option:selected").text()
    if name 
      $('#edit-title-tic').html(name)
    if (typeof xhr) == "object" && xhr.redirect != undefined
      window.location.href = xhr.redirect+"?just_created="+xhr.just_created      
    else
      tab_ = $("#int_action").val()
      if tab_
        str_ = " / "        
        $("#int-action-tic").html(str_ + '<a href="#">'+tab_+'</a>')
      $.scrollTo(0)
      $.unblockUI()

$(document).on "click", "a.resource-form-new-property", ->
    url = "/properties/new?ostatus=Purchased"
    $.ajax
      type: "get"
      url: url
      dataType: "html"
      success: (val) ->
        $("div#ResourceFormNewProperty").find(".model-body").html(val)
        #titleReset("Quick save entity")
      error: (e) ->
        console.log e
    $("div#ResourceFormNewProperty").modal()
    enable_datetimepicker_corporation()

$(document).on "hidden.bs.modal", "div#ResourceFormNewProperty", (data) ->
  #alert("pyt")
  #alert(data.id)
  #console.log(data)
  #var option = new Option()
  #$('#entity_property_id').append(option)
      
