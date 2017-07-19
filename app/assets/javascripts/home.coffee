$ ->
  if $(document).find('#is_show_initial_sign_in_modal').val() == 'true'
    # show initial sign in modal
    $(document).find('#md-welcome').modal('show')
  else
    # show landing page modal
    if $(document).find('#is_show_landing_page').val() == 'true'
      $(document).find('#md-landing').modal('show')
  
  $(document).find('#md-welcome .business_modal').on 'click', ->
    $(document).find('#md-welcome').modal('hide')
    $(document).find('#md-business').modal('show')

  $(document).find('#md-welcome .individual_modal').on 'click', ->
    $(document).find('#md-welcome').modal('hide')
    $(document).find('#md-individual').modal('show')

  $(document).find('.create_contact').submit (e)->
    e.preventDefault()
    contact_info = $(this).serialize()
    $.ajax
      url: '/users/set_contact_info/'
      type: 'POST'
      dataType: 'json'
      data: contact_info
      success: (data) ->
        if data.status
          $(document).find('.md-contact').modal('hide')
          $(document).find('#md-greeting .visitor').text(data.visitor)
          $(document).find('#md-greeting').modal('show')
        else
          $.notify "Failed", "error"

  $(document).find('#md-landing .close').on 'click', ->
    # if user log in first time
    if $(this).data('back-path') == "/users/sign_in"
      return true
    else if $(this).data('back-path') != "/"
      window.location.href = $(this).data('back-url')

  $(document).find('#create_client').on 'click', ->
    $('#md-greeting').modal('hide')
    $('#md-add-contact').modal('show')
  