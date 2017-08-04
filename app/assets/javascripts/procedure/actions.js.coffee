$ ->
  $(document).on 'ajax:beforeSend', 'a.new-procedure-action', ->
    $.blockUI()

  $(document).on 'ajax:success', 'a.new-procedure-action', (data, xhr, status)->
    $(this).parent().parent().parent().parent().append(xhr)
    container = $("div.actions-links")
    if container.is(':visible')
      container.hide();
    $.unblockUI()

  $(document).on 'ajax:beforeSend', '.new_procedure_action', ->
    $.blockUI()

  $(document).on 'ajax:success', '.new_procedure_action', (data, xhr, status)->
    $(this).parent().find('.actions').append(xhr)
    $(this).remove()
    $.unblockUI()

  $(document).on 'ajax:beforeSend', '.edit-procedure-action', ->
    $.blockUI()

  $(document).on 'ajax:success', '.edit-procedure-action', (data, xhr, status)->
    $('#EditProcedureAction').find('.modal-content').html(xhr)
    $('#EditProcedureAction').modal()
    $.unblockUI()

  $(document).on 'ajax:beforeSend', 'form.edit_procedure', ->
    $.blockUI()

  $(document).on 'ajax:success', 'form.edit_procedure', (data, xhr, status)->
    $.unblockUI()
    $('#EditProcedureAction').modal('hide')

  $(document).on 'ajax:beforeSend', '.show_procedure_action', ->
    $.blockUI()

  $(document).on 'ajax:success', '.show_procedure_action', (data, xhr, status)->
    $('#modelAction').find('.modal-content').html(xhr)
    $('#modelAction').modal()
    window.activate_image_lightbox()
    window.default_button_ui()
    $.unblockUI()

  $(document).on 'mouseover', '.procedure-action-title', ->
    id = $(this).attr('data-id')
    $(document).find('.procedure-action-title').editable '/procedure/actions/update/'+id,
      name: 'title'
      tooltip: 'click to edit..'
      indicator: 'Saving....'
      onblur : 'submit'
      callback: ->
#        fetch_action_checklist(pid)

  $(document).on 'click', 'a.procedure-actions', (e)->
    position = $(this).position()
    $(this).parent().find('div.actions-links').css('left', (position.left - 100) + 'px')
    $(this).parent().find('div.actions-links').toggle()

  $(document).on 'click', (e) ->
    if !$(e.target).hasClass('procedure-actions')
      container = $("div.actions-links")
      if (!container.is(e.target) && (container.has(e.target).length == 0))
        container.hide();
