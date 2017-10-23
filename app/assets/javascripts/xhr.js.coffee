$ ->
  $(document).on 'ajax:beforeSend', 'a.action_checklists', ->
    $.blockUI()

  $(document).on 'ajax:success', 'a.action_checklists', (data, xhr, status)->
    $('#actionChecklist').find('.modal-content').html(xhr)
    $('#actionChecklist').modal()
    $.unblockUI()

  $(document).on 'ajax:beforeSend', 'form.add-checklist', ->
    $.blockUI()

  $(document).on 'ajax:success', 'form.add-checklist', (data, xhr, status)->
    $('#actionChecklist').find('.modal-content').html(xhr)
    fetch_action_checklist($(this).attr('data-id'))
    $.unblockUI()

  $(document).on 'ajax:beforeSend', 'a.checklist-delete', ->
    $.blockUI()

  $(document).on 'ajax:complete', 'a.checklist-delete', (data, xhr, status)->
    try
      if xhr.responseText.toLowerCase() == 'ok'
        console.log($(this).attr('data-id'))
        fetch_action_checklist($(this).attr('data-id'))
        $(this).parent().parent().hide()
    catch e
    finally
      $.unblockUI()

  fetch_action_checklist = (id) ->
    url = '/procedure/actions/checklist_with_checkbox/' + id
    $.ajax
      type: "get"
      url: url
      dataType: "html"
      success: (val) ->
        console.log $(document).find('div.checklists[data-id="'+id+'"]')
        $(document).find('.checklists[data-id="'+id+'"]').html(val)
      error: (e) ->
        console.log e
  $(document).on 'click', '#checklist_checked', ->
    id = $(this).attr('data-id')
    url = '/procedure/actions/checklist_with_checkbox/' + id
    checked = this.checked
    if checked
      $(this).parent().find('span.checklist_title').css('text-decoration', 'line-through')
    else
      $(this).parent().find('span.checklist_title').css('text-decoration', 'none')
    $.ajax
      type: "patch"
      url: url
      data: {checked: checked}
      dataType: "html"
      success: (val) ->
      error: (e) ->


#      Inline EDIT
  $(document).on 'mouseover', '.checklist-title', ->
    id = $(this).attr('data-id')
    pid = $(this).attr('p-data-id')
    $(document).find('.checklist-title').editable '/procedure/actions/checklist_update/'+id,
      name: 'value'
      tooltip: 'click to edit..'
      indicator: 'Saving....'
      onblur : 'submit'
      callback: ->
        fetch_action_checklist(pid)

# Action Attachments
  $(document).on 'ajax:beforeSend', 'a.action_attachment', ->
    $.blockUI()

  $(document).on 'ajax:success', 'a.action_attachment', (data, xhr, status)->
    $('#actionAttachment').find('.modal-content').html(xhr)
    $('#actionAttachment').modal()
    $.unblockUI()

# Action Member
  $(document).on 'ajax:beforeSend', 'a.action_member', ->
    $.blockUI()

  $(document).on 'ajax:success', 'a.action_member', (data, xhr, status)->
    $('#actionMember').find('.modal-content').html(xhr)
    $('#actionMember').modal()
    $.unblockUI()

  $(document).on 'ajax:beforeSend', 'form.procedure_action_member', ->
    $.blockUI()

  $(document).on 'ajax:success', 'form.procedure_action_member', (data, xhr, status)->
    $('#actionMember').find('.modal-content').html(xhr)
    $.unblockUI()
