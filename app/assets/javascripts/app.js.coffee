lastChecked = null

$ ->
  $(document).on 'click', 'input#object_select', (e)->
    object_select_checkboxes = $('input#object_select')
    if !lastChecked
      lastChecked = this

    if e.shiftKey
      start = object_select_checkboxes.index(this)
      end = object_select_checkboxes.index(lastChecked)
      if start >= end
        object_select_checkboxes.slice(end, start + 1).prop 'checked', true
      else
        object_select_checkboxes.slice(start, end + 1).prop 'checked', false
    lastChecked = this
    checkbox_recheck()


  checkbox_recheck = ->
    data = ''
    $.each $(document).find('input#object_select'), ->
      data = "#{data}#{$(this).data('id')}," if this.checked

    $(document).find('input#multi_delete_objects').val(data)

  $(document).on 'click', 'a#multi_delete_objects_valid', (e)->
    if $(document).find('input#multi_delete_objects').val().length == 0
      swal('please select at least one checkbox')
    else
      $(document).find('input#multi_delete_objects_submit').trigger('click')

  $(document).on 'click', 'input#object_all', ->
    checked = this.checked
    $.each $(document).find('input[name="object_select"]'), ->
      $(this).prop('checked', checked)

    typewatch ->
      checkbox_recheck()
    , 200


  $(document).on 'click', 'input.manually_date', ->
    input_object = $(document).find("input##{$(this).data('class')}")
    unless input_object.data('name')
      input_object.data('name', input_object.attr('name'))

    $("select.#{$(this).data('class')}").each ->
      select_object = $(this)
      unless select_object.data('name')
        select_object.data('name', select_object.attr('name'))

    if this.checked
      input_object.show()
      input_object.attr('name', input_object.data('name'))

      $("select.#{$(this).data('class')}").each ->
        select_object = $(this)
        select_object.hide()
        select_object.attr('name', null)

    else

      $("select.#{$(this).data('class')}").each ->
        select_object = $(this)
        select_object.show()
        select_object.attr('name', select_object.data('name'))

      input_object.hide()
      input_object.attr('name', null)
  
  # Comming Soon Part
  $(document).on 'click', '.comming-soon',  -> 
    sweetAlert '', 'Under Construction', 'warning'
  
  flat_icheckbox = ->
    $(document).find('input.flat-icheck').iCheck
      checkboxClass: 'icheckbox_flat-blue'
      radioClass: 'iradio_flat-blue'

  input_mask_currency = ->
    $(document).find('input.input-mask-currency').inputmask
      alias: 'currency',
      rightAlign: false,
      prefix: '',
      removeMaskOnSubmit: true

  selectize_single = ->
    $(document).find('select.selectize-single').selectize
      create: false

  selectize_single_contact = ->
    $(document).find('select.selectize-single-contact').selectize
      create: false
      sortField: 'text'
      onChange: (value) ->
        if (!value.length)
          return
        else
          $.blockUI()
          typewatch ->
            entityFlag = $('#contact_is_company').val()
            $(document).find('#legal-ending-wrapper').hide()
            if value == 'Counter-Party'
              $(document).find('#contact-role_wrapper').hide()
              if entityFlag
                $(document).find('#legal-ending-wrapper').show()
            else
              $(document).find('#contact-role_wrapper').show()
              if value == 'Personnel'
                $(document).find('#cp-role-wrapper').hide()
                $(document).find('#per-role-wrapper').show()
              else
                $(document).find('#cp-role-wrapper').show()
                $(document).find('#per-role-wrapper').hide()
                if entityFlag
                  $(document).find('#legal-ending-wrapper').show()
            $.unblockUI()
          , 500


  selectize_single()
  selectize_single_contact()

  # iCheck checkbox
  flat_icheckbox()
  #Mask currency for input
  input_mask_currency()

  $(document).ajaxComplete ->
    selectize_single()
    selectize_single_contact()

  #Select file in Google Drive
  $().gdrive 'init',
    'devkey': $('#google_api_dev_key').val()
    'appid': $('#google_api_app_id').val()
  ###
   Difinition:
    Select in Google Drive Class name: select_in_gdrive
  ###
  init_select_in_google_drive = ->
    $(document).find('.select_in_gdrive').each (index) ->
      gdrive_file_id = '#' + $(this).find('input.form-control').attr("id")
      trigger_id = $(this).find('button.btn-gdrive').attr("id")
      $(gdrive_file_id).gdrive 'set',
        'trigger': trigger_id,
        'header': 'Select a file'
        'filter': ''

  init_select_in_google_drive()

  $(document).on 'ifChanged', '.to_do .field_list .task_status', (e)->
    if this.checked
      $(this).closest('li').prevAll().andSelf().find('.field_list').addClass('done')
      $(this).closest('li').prevAll().andSelf().find('.field_list .task_status').iCheck('check')
    else
      $(this).closest('li').nextAll().andSelf().find('.field_list').removeClass('done')
      $(this).closest('li').nextAll().andSelf().find('.field_list .task_status').iCheck('uncheck')

    if $('#purchase_sale_agreement_section .to_do .field_list .task_status').filter(':checked').length == $('#purchase_sale_agreement_section .to_do .field_list .task_status').length
      $(document).find('.side-menu>li>.nav.child_menu>li.current-page').addClass('in-contract')
    else
      $(document).find('.side-menu>li>.nav.child_menu>li.current-page').removeClass('in-contract')

  $('div.owns_tree').jstree
  'plugins': [
    'themes'
    'json_data'
    'ui'
  ]
  'json_data': 'ajax':
    'type': 'GET'
    'url': (node) ->
      nodeId = ''
      url = ''
      entityID = ''
      if node == -1
        entityID = $('#owner_entity').val()
        url = '/xhr/owns_list/' + entityID
      else
        nodeId = node.attr('id')
        url = '/xhr/owns_list/' + nodeId
      url
    'success': (new_data) ->
      new_data

  setTimeout (->
    $('.flash-message.normal_hide').hide 'slow', ->
      $('.flash-message.normal_hide').remove()
  ), 10000

  activeItem = $("#data_table tbody").attr('data-active-id')
  if (activeItem)
    $("#data_table tr[data-id='" + activeItem + "']").addClass('active-item')