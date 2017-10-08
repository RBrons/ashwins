$ ->
  $(document).on "click", "input[type='submit'].basic_info", (e)->
    self = this
    dom_ = $(document).find("#should_not_change_submit")
    val  = dom_.val()
    if val == "false"
      e.preventDefault()
      should_not_change_name              = $(document).find("#should_not_change_name").val()
      should_not_change_ein_or_ssn        = $(document).find("#should_not_change_ein_or_ssn").val()
      should_not_change_date_of_formation = $(document).find("#should_not_change_date_of_formation").val()
      if (should_not_change_name.length == 0) && (should_not_change_date_of_formation.length == 0) && (should_not_change_ein_or_ssn.length == 0)
        dom_.val("true")
        trigger_basic_info_form()
        return true
      name              = $(document).find("input[id$=_name]").val()
      ein_or_ssn        = $(document).find("input[id$=_ein_or_ssn]").val()
      date_of_formation = $(document).find("input[id$=_date_of_formation]").val()

      if (should_not_change_name.length > 0 && should_not_change_name != name)
        $(document).find("div#should-not-change-name").modal()
        return false
      else if (should_not_change_name.length == 0 && should_not_change_name != name)
        setTimeout(->
          $(document).find("input#should_not_change_name").val(name)
          trigger_basic_info_form()
        , 100)
        return false

      if (should_not_change_ein_or_ssn.length > 0 && should_not_change_ein_or_ssn != ein_or_ssn)
        $(document).find("div#should-not-change-ein").modal()
        return false
      else if (should_not_change_ein_or_ssn.length == 0 && should_not_change_ein_or_ssn != ein_or_ssn)
        setTimeout(->
          $(document).find("input#should_not_change_ein_or_ssn").val(ein_or_ssn)
          trigger_basic_info_form()
        , 100)
        return false

      if (should_not_change_date_of_formation.length > 0 && should_not_change_date_of_formation != date_of_formation)
        $(document).find("div#should-not-change-date-of-formation").modal()
        return false
      else if (should_not_change_date_of_formation.length == 0 && should_not_change_date_of_formation != date_of_formation)
        setTimeout(->
          $(document).find("input#should_not_change_date_of_formation").val(date_of_formation)
          trigger_basic_info_form()
        , 100)
        return false

      if should_not_change_date_of_formation == date_of_formation && should_not_change_ein_or_ssn == ein_or_ssn && should_not_change_name == name
        dom_.val("true")
        trigger_basic_info_form()
        return true

  $(document).on "click", "button.should-not-change-name-yes", ->
    $(document).find("input#should_not_change_name").val($(document).find("input#entity_name").val())
    $(document).find("div#should-not-change-name").modal("hide")
    trigger_basic_info_form()
  $(document).on "click", "button.should-not-change-ein-yes", ->
    $(document).find("input#should_not_change_ein_or_ssn").val($(document).find("input#entity_ein_or_ssn").val())
    $(document).find("div#should-not-change-ein").modal("hide")
    trigger_basic_info_form()
  $(document).on "click", "button.should-not-change-date-of-formation-yes", ->
    $(document).find("input#should_not_change_date_of_formation").val($(document).find("input#entity_date_of_formation").val())
    $(document).find("div#should-not-change-date-of-formation").modal("hide")
    trigger_basic_info_form()

  trigger_basic_info_form = ->
    $(document).find('.modal').each(->
      $(this).modal('hide');
    )
    $(document).find("div.modal-backdrop").hide()
    $(document).find("input[type='submit'].basic_info").trigger("click");

  if $(document).has("div#entity-creation-message")
    $(document).find("div#entity-creation-message").modal()
    setTimeout(->
      $(document).find("div#entity-creation-message").modal("hide")
    , 10000)

  if $(document).has("div#stockholder-empty-modal")
    $(document).find("div#stockholder-empty-modal").modal()
    setTimeout(->
      $(document).find("div#stockholder-empty-modal").modal("hide")
    , 10000)