$ ->
  user_role = 'Non-Attorney Fiduciary'

  if $(document).find('#is_show_initial_sign_in_modal').val() == 'true'
    # show initial sign in modal
    $(document).find('#md-welcome').modal('show')
  else
    # show landing page modal
    if $(document).find('#is_show_landing_page').val() == 'true'
      $(document).find('#md-landing').modal('show')
  
  $(document).find('#md-welcome .business_modal').on 'click', ->
    $(document).find('#md-welcome').modal('hide')
    $(document).find('#md-user-role .go-next').data('target-modal', '#md-business')
    $(document).find('#md-user-role').modal('show')
    
  $(document).find('#md-welcome .individual_modal').on 'click', ->
    $(document).find('#md-welcome').modal('hide')
    $(document).find('#md-user-role .go-next').data('target-modal', '#md-individual')
    $(document).find('#md-user-role').modal('show')

  $(document).find('#md-user-role .go-next').on 'click', -> 
    if user_role == 'Attorney' && $(this).data('target-modal') == '#md-business'
      $(document).find('#md-business .law-firm-detail input').prop('disabled', false)
      if $('.existing_firm option:selected').text() == "Other"
        $('.law-firm-detail .new_firm_field input').prop('disabled', false)
        $('.law-firm-detail .new_firm_field').show()
      else
        $('.law-firm-detail .new_firm_field input').prop('disabled', 'disabled')
        $('.law-firm-detail .new_firm_field').hide()
      $(document).find('#md-business .law-firm-detail').removeClass('hide')
      
      $(document).find('#md-business .business-detail input').prop('disabled', 'disabled')
      $(document).find('#md-business .business-detail').addClass('hide')
    else
      $(document).find('#md-business .law-firm-detail input, #md-business .law-firm-detail select').prop('disabled', 'disabled')
      $(document).find('#md-business .law-firm-detail').addClass('hide')

      $(document).find('#md-business .business-detail input').prop('disabled', false)
      $(document).find('#md-business .business-detail').removeClass('hide')

  $(document).find('.go-back, .go-next').on 'click', (e) ->
    e.preventDefault()
    $(this).closest('.modal').modal('hide')
    $(document).find($(this).data('target-modal')).modal('show')

  $(document).find('.attorney_user, .fiduciary_user').on 'click', ->
    if $('.attorney_user').is(':checked')
      user_role = 'Attorney'
    else if $('.fiduciary_user').is(':checked')
      user_role = 'Normal User'
    else
      user_role = 'Non-Attorney Fiduciary'
  
  $(document).find('select.existing_firm').on 'change', ->
    if $('.existing_firm option:selected').text() == "Other"
      $('.law-firm-detail .new_firm_field input').prop('disabled', false)
      $('.law-firm-detail .new_firm_field').show()
    else
      $('.law-firm-detail .new_firm_field input').prop('disabled', 'disabled')
      $('.law-firm-detail .new_firm_field').hide()

  $(document).find('.create_contact').submit (e) ->
    e.preventDefault()
    back_modal = $(this).closest('.md-contact').attr('id')
    $(this).find('input[name="user_type"]').val(user_role)
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
            $(document).find('#md-greeting span.depends_on_user_role').text('Holdings')
          else
            $(document).find('.top_nav .navbar-nav .client-module').html('Clients <span class="fa fa-plus-circle" id="add-client"></span>')
            $(document).find('#md-greeting span.depends_on_user_role').text('Clients')
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

  $(document).find('.exchangor-wrapper .create-initial-client').on 'click', ->
    $(document).find('#md-greeting').modal('hide')
    $(document).find('#md-add-initial-client').modal('show')
  
  $(document).find('.is_repls_business').on 'click', ->
    $(document).find('.replacement-seller-wrapper .repls-business-detail').show()

    $(document).find('.replacement-seller-wrapper .repls-individual-detail input').val('')
    $(document).find('.replacement-seller-wrapper .repls-individual-detail').hide()

    $(document).find('.replacement-seller-wrapper form input[name="contact[is_company]"]').val('true')

  $(document).find('.is_repls_individual').on 'click', ->
    $(document).find('.replacement-seller-wrapper .repls-business-detail input').val('')
    $(document).find('.replacement-seller-wrapper .repls-business-detail').hide()

    $(document).find('.replacement-seller-wrapper .repls-individual-detail').show()
    
    $(document).find('.replacement-seller-wrapper form input[name="contact[is_company]"]').val('false')

  
  $(document).find('.is_relinp_business').on 'click', ->
    $(document).find('.relinquishing-purchaser-wrapper .relinp-business-detail').show()
    
    $(document).find('.relinquishing-purchaser-wrapper .relinp-individual-detail input').val('')
    $(document).find('.relinquishing-purchaser-wrapper .relinp-individual-detail').hide()

    $(document).find('.relinquishing-purchaser-wrapper form input[name="contact[is_company]"]').val('true')
    

  $(document).find('.is_relinp_individual').on 'click', ->
    $(document).find('.relinquishing-purchaser-wrapper .relinp-business-detail input').val('')
    $(document).find('.relinquishing-purchaser-wrapper .relinp-business-detail').hide()

    $(document).find('.relinquishing-purchaser-wrapper .relinp-individual-detail').show()

    $(document).find('.relinquishing-purchaser-wrapper form input[name="contact[is_company]"]').val('false')
  
  $(document).find('.relinp-individual-detail input, .relinp-business-detail input').on 'blur', ->
    form = $(this).closest('form')
    if $(this).val() != ""
      if form.attr('action') != ""
        action_url = form.attr('action')
        type = 'PUT'
      else
        action_url = '/contacts/'
        type = 'POST'

      $.ajax
        url: action_url
        type: type
        dataType: 'json'
        data: form.serialize()
        success: (data) ->
          if data
            form.attr('action', '/contacts/' + data.id)
          else
            $.notify "Failed!", "error"

  $(document).find('.repls-individual-detail input, .repls-business-detail input').on 'blur', ->
    form = $(this).closest('form')
    if $(this).val() != ""
      if form.attr('action') != ""
        action_url = form.attr('action')
        type = 'PUT'
      else
        action_url = '/contacts/'
        type = 'POST'

      $.ajax
        url: action_url
        type: type
        dataType: 'json'
        data: form.serialize()
        success: (data) ->
          if data
            form.attr('action', '/contacts/' + data.id)
          else
            $.notify "Failed!", "error"
