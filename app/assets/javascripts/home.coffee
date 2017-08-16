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

  $(document).find('.go-back').on 'click', (e) ->
    e.preventDefault()
    $(this).closest('.modal').modal('hide')
    $(document).find($(this).data('target-modal')).modal('show')

  $(document).find('.attorney_user, .fiduciary_user').on 'click', ->
    if $('.attorney_user').is(':checked')
      $('form.create_contact input[name="user_type"]').val('Attorney')
    else if $('.fiduciary_user').is(':checked')
      $('form.create_contact input[name="user_type"]').val('Normal User')
    else
      $('form.create_contact input[name="user_type"]').val('Non-Attorney Fiduciary')
    
  $(document).find('.create_contact').submit (e) ->
    e.preventDefault()
    back_modal = $(this).closest('.md-contact').attr('id')
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
          $(document).find('#md-greeting .go-back').data('target-modal', '#' + back_modal)
          if data.user_type == 'Non-Attorney Fiduciary'
            $(document).find('.top_nav .navbar-nav .client-module').html('Holdings <span class="fa fa-plus-circle" id="add-client"></span>')
            console.log()
          $(document).find('#md-greeting').modal('show')
        else
          $.notify "Failed", "error"

  $(document).find('#md-landing .close').on 'click', ->
    window.location.href = $(this).data('back-url')

  $(document).find('#show_contact-modal').on 'click', ->
    $('#md-greeting').modal('hide')
    $('.top_nav #add-client').click()
  
  $(document).find('#show_demonstration').on 'click', ->
    sweetAlert 'Coming soon!', '', 'info'