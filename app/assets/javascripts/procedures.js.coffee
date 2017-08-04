$ ->
  $(document).on 'ajax:beforeSend', '.new_procedure', ->
    $.blockUI()

  $(document).on 'ajax:success', '.new_procedure', (data, xhr, status)->
    $(document).find('.procedure_form').remove()
    $(document).find('.middle-part-2').append(xhr)
    $.unblockUI()

  $(document).on 'click', '.procedure-form_cancel', ->
    $(document).find('.procedure_form').remove()