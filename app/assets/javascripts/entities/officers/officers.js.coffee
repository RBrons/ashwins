$ ->
  $(document).on "change", "select[id$=_person_type]", ->
    selected_val = $("option:selected", this).val()
    if selected_val == "Other"
      textField = '<input type="text" name="officer[person_type]" id="officer_person_type" style="clear: both; display: block; margin-top: 5px; margin-bottom: 5px; width: 60%" />'
      $(this).parent().append(textField)
    else
      $(document).find("input[id=officer_person_type]").remove()