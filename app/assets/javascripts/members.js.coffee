$ ->
  $(document).on 'ajax:beforeSend', 'a.new-member', ->
    $.blockUI()

  $(document).on 'ajax:success', 'a.new-member', (data, xhr, status)->
    $('#NewMember').find('.modal-content').html(xhr)
    $('#NewMember').modal()
    $.unblockUI()

  $(document).on 'ajax:beforeSend', 'a.edit-member', ->
    $.blockUI()

  $(document).on 'ajax:success', 'a.edit-member', (data, xhr, status)->
    $('#NewMember').find('.modal-content').html(xhr)
    $('#NewMember').modal()
    $.unblockUI()

  $(document).on 'ajax:beforeSend', 'form#new_member', ->
    $.blockUI()

  $(document).on 'ajax:complete', 'form#new_member', (data, xhr, status)->
    if xhr.responseText == 'ok'
      $(document).find('#NewMember').modal('hide')
      window.location.reload()
    else
      $(document).find('#NewMember').find('.modal-content').html(xhr.responseText)
    $.unblockUI()

  $(document).on 'ajax:beforeSend', 'form.edit_member', ->
    $.blockUI()

  $(document).on 'ajax:complete', 'form.edit_member', (data, xhr, status)->
    if xhr.responseText == 'ok'
      $(document).find('#NewMember').modal('hide')
      window.location.reload()
    else
      $(document).find('#NewMember').find('.modal-content').html(xhr.responseText)
    $.unblockUI()