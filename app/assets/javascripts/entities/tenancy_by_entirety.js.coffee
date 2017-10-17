$ ->
  $(document).on "click", "a.resource-form-new-property", ->
    url = "/properties/new?ostatus=Purchased"
    $(this).closest('.autocomplete').hide()
    $.ajax
      type: "get"
      url: url
      dataType: "html"
      success: (val) ->
        $("div#ResourceFormNewProperty").find(".model-body").html(val)
        titleReset("Quick save entity")
      error: (e) ->
        console.log e
    $("div#ResourceFormNewProperty").modal()
    enable_datetimepicker_corporation()

  $(document).on 'click', "a.resource-form-properties", ->
    url = "/properties"
    $.ajax
      type: "get"
      url: url
      dataType: "html"
      success: (val) ->
        $(document).find("div#ResourceFormProperties").find('.model-body').html(val)
      error: (e) ->
        console.log e
    $(document).find("div#ResourceFormProperties").modal()

  $(document).on "ajax:beforeSend", "form.new_property_xhr", ->
    $.blockUI()

  $(document).on "ajax:complete", "form.new_property_xhr", (data, xhr, status) ->
    try
      json = JSON.parse xhr.responseText
    catch e
      json = {}
    if json.id
      $("input[name$='entity_tenancy_by_entirety[property_id]']").val(json.id)
      $("input[name$='entity_tenancy_by_entirety[name]']").val(json.title)
      $("div#ResourceFormNewProperty").modal("hide")
    else
      $("div#ResourceFormNewProperty").find(".model-body").html(xhr.responseText)
      enable_datetimepicker_corporation()
    $.unblockUI()

  $(document).on "click", "div.entity-object-action", ->
    val = $(this).text()
    id  = $(this).parent().attr("data-id")
    $("input[name$='entity_tenancy_by_entirety[property_id]']").val(id)
    $("input[name$='entity_tenancy_by_entirety[name]']").val(val)
    $(document).find("div#ResourceFormProperties").modal("hide")

  $(document).on "ajax:success", "a.entity-page-xhr, form.entity-page-xhr", (data, xhr, status) ->
    name = $("#entity_tenancy_by_entirety_property_id option:selected").text()
    if name
      $('#edit-title-tbe').html(name)
    if (typeof xhr) == "object" && xhr.redirect != undefined
      window.location.href = xhr.redirect + "?just_created=" + xhr.just_created
    else
      tab_ = $("#int_action").val()
      if tab_ == 'Spouses List'
        $('.tbe_icp_list').text('Tenants by the Entirety Spouses List View')
      else
        $('.tbe_icp_list').text('')
      
      if tab_
        str_ = " / "
        $("#int-action-tbe").html(str_ + '<a href="#">' + tab_ + '</a>')
      $.scrollTo(0)
      $.unblockUI()
