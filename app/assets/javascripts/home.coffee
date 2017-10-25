$ ->
  isLeavingUserSetup = false

  attorney_type = 'LawFirm' # Individual or LawFirm
  # replacement seller
  repls_contact_id = $(document).find('input.repls_contact_id').val()
  repls_contact_type = ""
  repls_name = ""
  repls_info_html = ""

  # relinquishing purchaser
  relinp_id = $(document).find('input.relinp_id').val()
  relinp_info_html = ""
  
  # relinqushing seller
  exchangor_entity_id = $(document).find('input.exchangor_entity_id').val()
  exchangor_entity_type = $(document).find('input.exchangor_entity_type').val()
  exchangor_name = $(document).find('input.exchangor_name').val()
  exchangor_info_html = ''
  
  # relinquishing property
  purchased_property_id = $(document).find('input.purchased_property_id').val()
  purchased_info_html = ''
  
  # replacement property
  replacement_property_id = $(document).find('input.replacement_property_id').val()
  replacement_property_info_html = ''

  # when user leave user setup sequence
  $(document).on 'click', '.navbar-nav a', (e) ->
    if e.target.nodeName == 'A'
      isLeavingUserSetup = true
  
  $(window).on 'beforeunload', ->
    if $('body').hasClass('user-setup-page')
      if isLeavingUserSetup
        console.log 'user is leaving user-setup page...'
        $.ajax
          url: '/xhr/skip_user_setup/'
          type: 'POST'
          dataType: 'json'
      return undefined
          
  # show initial participants modal
  if $(document).find('#md-initial-participants').length > 0
    $(document).find('#md-initial-participants').modal('show')
    $('body').addClass('ipp-page')

  if $(document).find('#show_initial_sign_in_modal').val() == 'true'
    # show user setup sequence
    $(document).find('#md-us-step1').modal('show')
    $('body').addClass('user-setup-page')
  else
    # show landing page modal
    if $(document).find('#is_show_landing_page').val() == 'true'
      $(document).find('#md-landing').modal('show')
  
  $(document).find('.md-user-setup').on 'shown', ->
    modal = $(this)
    if modal.attr('id') == 'md-us-step4'
      if attorney_type == 'LawFirm'
        modal.find('.law_firm_position').show()
        modal.find('.law_firm_position select').attr('disabled', false)
        modal.find('.individual_attorney_position').hide()
        modal.find('.individual_attorney_position select').attr('disabled', 'disabled')
      else if attorney_type == 'Individual'
        modal.find('.law_firm_position').hide()
        modal.find('.law_firm_position select').attr('disabled', 'disabled')
        modal.find('.individual_attorney_position').show()
        modal.find('.individual_attorney_position select').attr('disabled', false)

    $(document).find('.user-setup-wizard a').each (index) ->
      if $(this).data('step') < modal.data('us-step')
        $(this).removeClass()
               .addClass('done')
      else if $(this).data('step') == modal.data('us-step')
        $(this).removeClass()
               .addClass('selected')
      else if $(this).data('step') > modal.data('us-step')
        $(this).removeClass()
              .addClass('disabled')

  $(document).find('.individual_attorney, .law_firm').on 'change', ->
    if $('.individual_attorney').is(':checked')
      $(this).closest('.md-user-setup').find('.next-step').attr('data-target', '#md-individual')
      attorney_type = 'Individual'
    else if $('.law_firm').is(':checked')
      $(this).closest('.md-user-setup').find('.next-step').attr('data-target', '#md-business')
      attorney_type = 'LawFirm'
      
  $(document).find('.real-attorney, .affiliate-attorney').on 'change', ->
    if $('.real-attorney').is(':checked')
      $(this).closest('.md-user-setup').find('.law-firm-detail').hide()
      $(this).closest('.md-user-setup').find('select.existing_firm option:first-child').attr("selected", true)
      $(this).closest('.md-user-setup').addClass('last-step')
    else if $('.affiliate-attorney').is(':checked')
      $(this).closest('.md-user-setup').find('.law-firm-detail').show()
      $(this).closest('.md-user-setup').removeClass('last-step')
        
  $(document).find('select.existing_firm').on 'change', ->
    modal = $(this).closest('.md-user-setup')
    if $(this).find('option:selected').text() == ""
      modal.find('.law-firm-detail .new_firm_field').hide()
      modal.find('.shared-field').hide()
    else
      if $(this).find('option:selected').text() == "Add"
        modal.find('.law-firm-detail .new_firm_field input').prop('disabled', false)
        modal.find('.law-firm-detail .new_firm_field').show()
      else
        modal.find('.law-firm-detail .new_firm_field input').prop('disabled', 'disabled')
        modal.find('.law-firm-detail .new_firm_field').hide()
      
  $(document).find('.create_contact').submit (e) ->
    e.preventDefault()
    modal = $(this).closest('.md-user-setup')
    if modal.attr('id') == 'md-business'
      if !$(this).find('select.existing_firm').val()
        $.notify 'Please select law firm!', 'error'
        return false
    
    contact_info = $(this).serialize()
    $.ajax
      url: '/users/set_contact_info/'
      type: 'POST'
      dataType: 'json'
      data: contact_info
      success: (data) ->
        if data.status
          modal.modal('hide')
          if modal.hasClass('last-step')
            window.location.href = '/'
          else
            next_modal = "#md-us-step" + (parseInt(modal.data('us-step')) + 1)
            $(document).find(next_modal).modal('show')
        else
          $.notify "Failed", "error"

  $(document).find('#md-landing .close').on 'click', ->
    window.location.href = $(this).data('back-url')

  $(document).find('.exchangor-wrapper .create-initial-client-type').on 'click', ->
    if $(document).find('.exchangor-wrapper form input[name="entity[name]"]').val() == ''
      sweetAlert('First input the Name', '', 'info')
      return false
    $(document).find('#md-add-initial-client').modal('show')
  
  $(document).find('.is_entity_business').on 'click', ->
    $(document).find('.exchangor-wrapper form .form-group').show()
    $(document).find('.exchangor-wrapper .entity-business-detail').show()
    
    $(document).find('.exchangor-wrapper .entity-individual-detail input').val('')
    $(document).find('.exchangor-wrapper .entity-individual-detail').hide()
    
    $(document).find('.exchangor-wrapper form input[name="entity_type"]').val('business')

  $(document).find('.is_entity_individual').on 'click', ->
    $(document).find('.exchangor-wrapper form .form-group').show()
    $(document).find('.exchangor-wrapper .entity-business-detail input').val('')
    $(document).find('.exchangor-wrapper .entity-business-detail').hide()

    $(document).find('.exchangor-wrapper .entity-individual-detail').show()
    
    $(document).find('.exchangor-wrapper form input[name="entity_type"]').val('individual')

  $(document).find('#md-add-initial-client ul li').on 'click', ->
    entity_em = $(this)
    form = $(document).find('.exchangor-wrapper form')
    if form.find('input[name="entity[name]"]').val() != ''
      entity_business_name = form.find('input[name="entity[name]"]').val()
    else
      return false
    switch entity_em.data('entity-name')
      when 'Sole Proprietorship'
        legal_ending = ''
        legal_ending_html = 'Sole Proprietorship'
      when 'Partnership'
        legal_ending = 'Partners'
        legal_ending_html = 'Partnership'
      when 'LLC'
        legal_ending = 'LLC'
        legal_ending_html = 'LLC'
      when 'Limited Partnership'
        legal_ending = 'LP'
        legal_ending_html = 'LP'
      when 'Corporation'
        legal_ending = ''
        legal_ending_html = '<select class="select_auto corporation_legal_ending"><option>Inc</option><option>Corp</option><option>Ltd</option></select>'
      
    entity_params =  {}
    if parseInt(exchangor_entity_id)
      url = '/xhr/update_entity'
      entity_params['entity[id]'] = exchangor_entity_id
    else
      url = '/xhr/create_entity'
    entity_params['entity[name]'] = entity_business_name
    entity_params['entity[type_]'] = entity_em.data('entity-type')
    entity_params['entity[legal_ending]'] = legal_ending
    
    $.ajax
      url: url
      type: 'POST'
      dataType: 'json'
      data: entity_params
      success: (data) ->
        if data.id
          exchangor_entity_id = data.id
          exchangor_entity_type = entity_em.data('entity-name')
          exchangor_name = data.name
          exchangor_info_html = '<span class="text-success">' + exchangor_name + ', ' + legal_ending_html + ' will be your first Exchangor</span>' +
                                '<a class="margin-sm-left" data-entity-id="' + exchangor_entity_id + '" href="#" id="edit-ipp-exchangor"><i class="fa fa-edit"></i></a>'
          $(document).find('.exchangor-info').html(exchangor_info_html)
          $(document).find('.exchangor-info').removeClass('text-cancel')
          $(document).find('.exchangor-wrapper .form-wrapper').hide()
          
          $(document).find('#md-add-initial-client').modal('hide')
          if exchangor_entity_id && purchased_property_id && relinp_id && repls_contact_id && replacement_property_id
            $(document).find('#completed-ipp').show()
            $(document).find('.final-step').removeAttr('data-dismiss')
            $(document).find('.final-step').attr('href', $(document).find('.final-step').data('done-href'))
            $(document).find('.final-step').text('Done')
          else
            $(document).find('.final-step').text('Skip This Step')
        else
          $.notify "Failed!", "error"
    
  $(document).on 'change', '.corporation_legal_ending', ->
    console.log $(this).find('option:selected').text()
    entity_params = {}
    entity_params['entity[id]'] = exchangor_entity_id
    entity_params['entity[legal_ending]'] = $(this).find('option:selected').text()
    $.ajax
      url: '/xhr/update_entity'
      type: 'POST'
      dataType: 'json'
      data: entity_params
      success: (data) ->
        if data
          console.log 'success'
          
  $(document).find('.is_repls_business').on 'click', ->
    $(document).find('.replacement-seller-wrapper form .form-group').show()
    $(document).find('.replacement-seller-wrapper .repls-business-detail').show()

    $(document).find('.replacement-seller-wrapper .repls-individual-detail input').val('')
    $(document).find('.replacement-seller-wrapper .repls-individual-detail').hide()

    $(document).find('.replacement-seller-wrapper form input[name="contact[is_company]"]').val('true')
    repls_contact_type = 'business'

  $(document).find('.is_repls_individual').on 'click', ->
    $(document).find('.replacement-seller-wrapper form .form-group').show()
    $(document).find('.replacement-seller-wrapper .repls-business-detail input').val('')
    $(document).find('.replacement-seller-wrapper .repls-business-detail').hide()

    $(document).find('.replacement-seller-wrapper .repls-individual-detail').show()
    
    $(document).find('.replacement-seller-wrapper form input[name="contact[is_company]"]').val('false')
    repls_contact_type = 'individual'

  
  $(document).find('.is_relinp_business').on 'click', ->
    $(document).find('.relinquishing-purchaser-wrapper form .form-group').show()
    $(document).find('.relinquishing-purchaser-wrapper .relinp-business-detail').show()
    
    $(document).find('.relinquishing-purchaser-wrapper .relinp-individual-detail input').val('')
    $(document).find('.relinquishing-purchaser-wrapper .relinp-individual-detail').hide()

    $(document).find('.relinquishing-purchaser-wrapper form input[name="contact[is_company]"]').val('true')
    

  $(document).find('.is_relinp_individual').on 'click', ->
    $(document).find('.relinquishing-purchaser-wrapper form .form-group').show()
    $(document).find('.relinquishing-purchaser-wrapper .relinp-business-detail input').val('')
    $(document).find('.relinquishing-purchaser-wrapper .relinp-business-detail').hide()

    $(document).find('.relinquishing-purchaser-wrapper .relinp-individual-detail').show()

    $(document).find('.relinquishing-purchaser-wrapper form input[name="contact[is_company]"]').val('false')

  $(document).find('.entity-individual-detail input').on 'blur keypress', (e)->
    form = $(this).closest('form')
    current_em = $(this)
    if e.type == 'blur' || e.keyCode == 13
      none_empty_inputs = form.find('.entity-individual-detail input').filter ->
          return this.value != ''
      if none_empty_inputs.length != 2
        return false
      if parseInt(exchangor_entity_id)
        url = '/xhr/update_entity'
        form.find('input[name="entity[id]"]').val(exchangor_entity_id)
      else
        url = '/xhr/create_entity'
      
      $.ajax
        url: url
        type: 'POST'
        dataType: 'json'
        data: form.serialize()
        success: (data) ->
          if data.id
            exchangor_entity_id = data.id
            exchangor_entity_type = 'Individual'
            if data.first_name && data.last_name
              exchangor_name = data.first_name + ' ' + data.last_name
              exchangor_info_html = '<span class="text-success">You have created a data record for ' + exchangor_name + ' to be your first Exchangor.</span>' + 
                                    '<a class="margin-sm-left" data-entity-id="' + exchangor_entity_id + '" href="#" id="edit-ipp-exchangor"><i class="fa fa-edit"></i></a>'
              $(document).find('.exchangor-wrapper .create-initial-client-type').hide()
              $(document).find('.exchangor-info').html(exchangor_info_html)
              $(document).find('.exchangor-info').removeClass('text-cancel')
              $(document).find('.exchangor-wrapper .form-wrapper').hide()
              current_em.off('blur')
              
            if exchangor_entity_id && purchased_property_id && relinp_id && repls_contact_id && replacement_property_id
              $(document).find('#completed-ipp').show()
              $(document).find('.final-step').removeAttr('data-dismiss')
              $(document).find('.final-step').attr('href', $(document).find('.final-step').data('done-href'))
              $(document).find('.final-step').text('Next')
            else
              $(document).find('.final-step').text('Skip This Step')
          else
            $.notify "Failed!", "error"
  
  $(document).on 'click', '#edit-ipp-exchangor', ->
    $(document).find('.exchangor-info').addClass('text-cancel')
    $(document).find('.exchangor-wrapper .form-wrapper').show()
  
  $(document).find('.entity-business-detail input').on 'blur keypress', (e) ->
    if e.type == 'blur' || e.keyCode == 13
      if $(this).val() == ''
        sweetAlert('First input the Name', '', 'info')
        return false
      $(document).find('#md-add-initial-client').modal('show')

  $(document).find('.relinp-individual-detail input, .relinp-business-detail input').on 'blur keypress', (e)->
    form = $(this).closest('form')
    current_em = $(this)
    if e.type == 'blur' || e.keyCode == 13
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
            if data.id
              form.attr('action', '/contacts/' + data.id)
              relinp_id = data.id
              relinp_info_html = ''
              if data.is_company
                relinp_info_html = '<span class="text-success">You have created a data record for ' + data.company_name + ' to be your first Purchaser.</span>'
              else if data.first_name != '' && data.last_name != ""
                relinp_info_html = '<span class="text-success">You have created a data record for ' + data.first_name + ' ' + data.last_name + ' to be your first Purchaser.</span>'
              if relinp_info_html != ""
                relinp_info_html += '<a class="margin-sm-left" data-contact-id="' + relinp_id + '" href="#" id="edit-ipp-relinq_purchaser"><i class="fa fa-edit"></i></a>'
                $(document).find('.relinquishing-purchaser-info').removeClass('text-cancel')
                $(document).find('.relinquishing-purchaser-info').html(relinp_info_html)
                $(document).find('.relinquishing-purchaser-wrapper form').hide()
                current_em.off('blur')

              if exchangor_entity_id && purchased_property_id && relinp_id && repls_contact_id && replacement_property_id
                $(document).find('#completed-ipp').show()
                $(document).find('.final-step').removeAttr('data-dismiss')
                $(document).find('.final-step').attr('href', $(document).find('.final-step').data('done-href'))
                $(document).find('.final-step').text('Next')
              else
                $(document).find('.final-step').text('Skip This Step')
            else
              $.notify "Failed!", "error"

  $(document).on 'click', '#edit-ipp-relinq_purchaser', (e) ->
    $(document).find('.relinquishing-purchaser-info').addClass('text-cancel')
    $(document).find('.relinquishing-purchaser-wrapper form').attr('action', '/contacts/' + relinp_id)
    $(document).find('.relinquishing-purchaser-wrapper form').show()

  $(document).find('.repls-individual-detail input, .repls-business-detail input').on 'blur keypress', (e)->
    form = $(this).closest('form')
    current_em = $(this)
    if e.type == 'blur' || e.keyCode == 13
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
            if data.id
              form.attr('action', '/contacts/' + data.id)
              repls_contact_id = data.id
              repls_info_html = ''
              if data.is_company
                repls_info_html = '<span class="text-success">You have created a data record for ' + data.company_name + ' to be your first Seller.</span>'
                repls_name = data.company_name
              else if data.first_name != '' && data.last_name != ""
                repls_info_html = '<span class="text-success">You have created a data record for ' + data.first_name + ' ' + data.last_name + ' to be your first Seller.</span>'
                repls_name = data.first_name + ' ' + data.last_name
              if repls_info_html != ""
                repls_info_html += '<a class="margin-sm-left" data-contact-id="' + repls_contact_id + '" href="#" id="edit-ipp-replacement_seller"><i class="fa fa-edit"></i></a>'
                $(document).find('.replacement-seller-info').removeClass('text-cancel')
                $(document).find('.replacement-seller-info').html(repls_info_html)
                $(document).find('.replacement-seller-wrapper form').hide()
                current_em.off('blur')

              if exchangor_entity_id && purchased_property_id && relinp_id && repls_contact_id && replacement_property_id
                $(document).find('#completed-ipp').show()
                $(document).find('.final-step').removeAttr('data-dismiss')
                $(document).find('.final-step').attr('href', $(document).find('.final-step').data('done-href'))
                $(document).find('.final-step').text('Next')
              else
                $(document).find('.final-step').text('Skip This Step')
            else
              $.notify "Failed!", "error"
  
  $(document).on 'click', '#edit-ipp-replacement_seller', (e) ->
    $(document).find('.replacement-seller-info').addClass('text-cancel')
    $(document).find('.replacement-seller-wrapper form').attr('action', '/contacts/' + repls_contact_id)
    $(document).find('.replacement-seller-wrapper form').show()

  $(document).on 'click', '.create-exchangor-property', ->
    if parseInt(exchangor_entity_id) == 0 || exchangor_entity_id == undefined
      sweetAlert 'First create your Exchangor', '', 'info'
      return
    
    form = $(document).find('#md-new-property form')
    form.parsley().reset()
    form.find('input').val('')
    form.find('#has-lease-rent').iCheck('uncheck')
    form.find('.fields_for_create input').attr('disabled', false)
    form.find('input#ostatus').val('Purchased')
    form.find('input#property_ownership_status').val('Purchased')
    if exchangor_entity_type == 'Individual'
      form.find('input#property_owner_entity_id').val('')
      form.find('input#property_owner_entity_id_indv').val(exchangor_entity_id)
      form.find('input#property_owner_person_is').val(1)
    else
      form.find('input#property_owner_entity_id').val(exchangor_entity_id)
      form.find('input#property_owner_entity_id_indv').val('')
      form.find('input#property_owner_person_is').val(0)
    $(document).find('#md-new-property').modal('show')
  
  $(document).on 'click', '#edit-ipp-purchased-property', (e) ->
    form = $(document).find('#md-new-property form')
    form.find('#has-lease-rent').iCheck('uncheck')
    $(document).find('.purchased-property-info').addClass('text-cancel')
    if exchangor_entity_type == 'Individual'
      form.find('input#property_owner_person_is').val(1)
    else
      form.find('input#property_owner_person_is').val(0)

    if parseInt(purchased_property_id) != 0
      form.find("input[name='_method']").val('patch')
      form.attr('action', '/properties/' + purchased_property_id)
    else
      form.find("input[name='_method']").val('post')
      form.attr('action', '/properties/')

    form.find('.fields_for_create input').attr('disabled', true)
    $(document).find('#md-new-property').modal('show')

  $(document).on 'click', '#cancel-property, #md-new-property button.close', (e) ->
    $(document).find('.purchased-property-info').removeClass('text-cancel')

  $(document).on 'click', '.create-seller-property', ->
    if parseInt(repls_contact_id) == 0 || repls_contact_id == undefined
      sweetAlert 'First create your\n Replacement Seller', '', 'info'
      return

    form = $(document).find('#md-new-property form')
    form.parsley().reset()
    form.find('input').val('')
    form.find('#has-lease-rent').iCheck('uncheck')
    form.find('input#ostatus').val('Prospective Purchase')
    form.find('input#property_ownership_status').val('Prospective Purchase')
    if repls_contact_type == 'business'
      form.find('input#property_owner_entity_id').val(repls_contact_id)
      form.find('input#property_owner_entity_id_indv').val('')
      form.find('input#property_owner_person_is').val(0)
    else
      form.find('input#property_owner_entity_id').val('')
      form.find('input#property_owner_entity_id_indv').val(repls_contact_id)
      form.find('input#property_owner_person_is').val(1)
    $(document).find('#md-new-property').modal('show')
  
  $(document).on 'click', '#edit-ipp-prospective-property', (e) ->
    form = $(document).find('#md-new-property form')
    form.find('#has-lease-rent').iCheck('uncheck')
    $(document).find('.prospective-property-info').addClass('text-cancel')
    if repls_contact_type == 'business'
      form.find('input#property_owner_person_is').val(0)
    else
      form.find('input#property_owner_person_is').val(1)

    if parseInt(replacement_property_id) != 0
      form.find("input[name='_method']").val('patch')
      form.attr('action', '/properties/' + replacement_property_id)
    else
      form.find("input[name='_method']").val('post')
      form.attr('action', '/properties/')

    form.find('.fields_for_create input').attr('disabled', true)
    $(document).find('#md-new-property').modal('show')

  $(document).find('#md-new-property form select#property_tenant_id').on 'change', ->
    form = $(document).find('#md-new-property form')
    if $(this).find('option:selected').text() == 'No Tenant'
      $('#property_rent_price').prop('required', false)
    else
      $('#property_rent_price').prop('required', true)
    
    if form.find('#property_location_city').val() != ""
      form.find('#property_title').val($(this).find('option:selected').text() + ', ' + form.find('#property_location_city').val())
    else
      form.find('#property_title').val('')
        
  $(document).find('#md-new-property form #property_location_city').on 'change', ->
    form = $(document).find('#md-new-property form')
    if $(this).val() != ""
      form.find('#property_title').val(form.find('select#property_tenant_id option:selected').text() + ', ' + $(this).val())
    else
      form.find('#property_title').val('')
      
  $(document).on 'ajax:complete', '#md-new-property form', (e, data, status, xhr) ->
    $.notify 'Success', 'success'
    $(document).find('#md-new-property').modal('hide')
    if JSON.parse(data.responseText).ownership_status == 'Purchased'
      purchased_property_id = JSON.parse(data.responseText).id
      purchased_info_html = '<span class="text-success">You have a created a data record for ' + JSON.parse(data.responseText).title + ' to be the first Purchased Property of ' + exchangor_name + '</span>.' + 
                            '<a class="margin-sm-left" data-property-id="' + purchased_property_id + '" href="#" id="edit-ipp-purchased-property"><i class="fa fa-edit"></i></a>'
      $(document).find('.purchased-property-info').removeClass('text-cancel')
      $(document).find('.purchased-property-info').html(purchased_info_html)
    else
      replacement_property_id = JSON.parse(data.responseText).id
      replacement_property_info_html = '<span class="text-success">You have a created a data record for ' + JSON.parse(data.responseText).title + ' to be the first Prospective Purchase Property of ' + repls_name + '</span>.' + 
                                       '<a class="margin-sm-left" data-property-id="' + replacement_property_id + '" href="#" id="edit-ipp-prospective-property"><i class="fa fa-edit"></i></a>'
      $(document).find('.prospective-property-info').removeClass('text-cancel')
      $(document).find('.prospective-property-info').html(replacement_property_info_html)
    
    if exchangor_entity_id && purchased_property_id && relinp_id && repls_contact_id && replacement_property_id
      $(document).find('#completed-ipp').show()
      $(document).find('.final-step').removeAttr('data-dismiss')
      $(document).find('.final-step').attr('href', $(document).find('.final-step').data('done-href'))
      $(document).find('.final-step').text('Next')
    else
      $(document).find('.final-step').text('Skip This Step')
  $(document).find('.new-tenant-button').on 'click', ->
    console.log 'new tenant'
  
  $(document).find('#md-new-property form').parsley(
    errorsContainer: (em) -> 
        $err = em.$element.parents('.form-group').find('.error-msg')
        return $err
  )

  $(document).on 'ifChanged', '#has-lease-rent', ->
    if this.checked
      $('#property_rent_price').prop('required', false)
      $('#property_rent_price').closest('.form-group').find('label').text('Rent')
      $('#property_rent_price').val('')
    else
      $('#property_rent_price').prop('required', true)
      $('#property_rent_price').closest('.form-group').find('label').text('Rent *')

  $('table#pt_data_table').DataTable
    'oLanguage': 'sEmptyTable': 'You have not engaged in any Transactions, when you do, this tab will track your activity.'
    'bSort': false
    'bPaginate': true
    'bInfo': false
    'bFilter': false
    'iDisplayLength': 20
    'fnDrawCallback': ->
      paginate = this.siblings('.dataTables_paginate')
      if this.api().data().length <= this.fnSettings()._iDisplayLength
        paginate.hide()
      else
        paginate.show()
      
  $(document).find('#pt_data_table_length').hide()