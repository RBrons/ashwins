
$ ->
  # Global Variables
  selected_offer_tab = $(document).find($(document).find('#offer_list li.active a').attr('href'))
  selected_basket_tab = $(document).find($(document).find('#basket_list li.active a').attr('href'))
  selected_transaction_sub_tab = $(document).find($(document).find('#sale_buy_step_tab li.active a').attr('href'))
  last_counteroffer = ""
  not_passed_LOI = 'You are proceeding to contract without completing the LOI. Are you sure you want to do this?'
  success_identify_property_to_qi = "Now that you have Identified one or more properties to your QI, please make a counter offer to a seller and hit Save and Next"
  percent_95_warning = "The 95% rule is extremely hazardous to a buyer.  Also, it is not fully supported by this app."
  alert_for_three_property_rule = "Because you selected three property rule, you can not select any more properties to buy"

  sub_tab_id = $("#sub_tab_val").val()
  sub_sub_tab_id = $("#sub_sub_tab_val").val()
  if sub_tab_id
    $("#" + sub_tab_id).click()
  if sub_sub_tab_id
    $("#" + sub_sub_tab_id).click()

  #Transaction List
  $(document).on 'click', '#data_table.sale_mode tbody td.details-control, #data_table.purchase_mode tbody td.details-control', ->
    tr = $(this).closest('tr')
    if tr.hasClass 'shown'
      tr.nextUntil('.parent-row').hide()
      tr.nextUntil('.parent-row').removeClass('striped-row')
      tr.removeClass 'shown'
    else
      tr.nextUntil('.parent-row').show()
      tr.nextUntil('.parent-row').addClass('striped-row')
      tr.addClass 'shown'

  $(document).on 'ifChanged', '#show-transaction-deadline', ->
    if this.checked
      $(document).find('#data_table.sale_mode tbody tr td span.deadline-detail').show()
    else
      $(document).find('#data_table.sale_mode tbody tr td span.deadline-detail').hide()

  # Save & Next button
  $(document).on 'click', '.no-submit-form', ->
    $('#sale_buy_step_tab li.active').next().find('a').click()

  $(document).on 'click', '#save-and-next', (e) ->
    e.preventDefault()
    save_and_next_btn_in_step = $(document).find('.save_next_in_step')
    if save_and_next_btn_in_step.length > 1
      save_and_next_btn_in_step = selected_transaction_sub_tab.find('.save_next_in_step')
      if save_and_next_btn_in_step.length == 1
        save_and_next_btn_in_step.click()
      else if save_and_next_btn_in_step.length == 0
        if $('#sale_buy_step_tab li.active').nextAll().length >= 1
          $('#sale_buy_step_tab li.active').next().find('a').click()
        else
          next_step = $(document).find('ul.wizard_steps li.selected').next()
          window.location.href = next_step.find('a').attr("href")
    else if save_and_next_btn_in_step.length == 1
      save_and_next_btn_in_step.click()
    else
      if $('#sale_buy_step_tab li.active').nextAll().length >= 1
          $('#sale_buy_step_tab li.active').next().find('a').click()
      else
        next_step = $(document).find('ul.wizard_steps li.selected').next()
        window.location.href = next_step.find('a').attr("href")

  #---- Sale ----#
  $(document).on 'ifChecked', '#transaction_seller_person_is_true', ->
    $(document).find('div.sale-tr-pr-detail').show()
    $(document).find('div.sale-tr-et-detail').hide()

    if !($(".sale-tr-pr-detail .selectize-single-transaction").val() > 0)
      $(".sale-step1-form input[type=submit]").hide()
      $("#save-and-next").hide()
    else
      $(".sale-step1-form input[type=submit]").show()
      $("#save-and-next").show()

  $(document).on 'ifChecked', '#transaction_seller_person_is_false', ->
    $(document).find('div.sale-tr-pr-detail').hide()
    $(document).find('div.sale-tr-et-detail').show()

    if !($(".sale-tr-et-detail .selectize-single-transaction").val() > 0)
      $(".sale-step1-form input[type=submit]").hide()
      $("#save-and-next").hide()
    else
      $(".sale-step1-form input[type=submit]").show()
      $("#save-and-next").show()

  if !($(document).find(".sale-tr-et-detail .selectize-single-transaction").val() > 0) && !($(document).find(".sale-tr-pr-detail .selectize-single-transaction").val() > 0) && $(document).find(".sale-step1-form").length > 0
    $("#save-and-next").hide()

  $(document).find("select.selectize-single-transaction").selectize
    create: false
    onChange: (value) ->
      if !(value > 0 )
        $(".sale-step1-form input[type=submit]").hide()
        $("#save-and-next").hide()
      else
        $(".sale-step1-form input[type=submit]").show()
        $("#save-and-next").show()

  #---- Purchase ----#
  $(document).on 'ifChecked', '#transaction_purchaser_person_is_true', ->
    if this.checked
      $(document).find('div.purchase-tr-pr-detail').show()
      $(document).find('div.purchase-tr-et-detail').hide()

  $(document).on 'ifChecked', '#transaction_purchaser_person_is_false', ->
    if this.checked
      $(document).find('div.purchase-tr-pr-detail').hide()
      $(document).find('div.purchase-tr-et-detail').show()


  sale_pre_loi_text = (seller)-> '<strong>Congratulations!</strong> You have just initiated a 1031 Exchange on behalf of <strong>'+seller+'</strong>. You can now identify the ' +
    ' property that you wish to relinquish, hire a Qualified Intermediary, set a sales price and input a broker. Please ' +
    'be sure to input the progress of your Exchange by updating the Status dropdown. All changes will be updated in ' +
    ' Status Tab'

  sale_loi_to_psa = -> '<strong>Congratulations!</strong> You have found a potential buyer for the property that you wish to ' +
    'relinquish. Please fill out the Prospective Purchaser and use the Document tab to create a compelling competitive Letter ' +
    'of intent to entice the buyer into snapping up your "hot to trot" property!. if the buyer accepts the terms of the ' +
    'LOI, negotiate a Purchase Sale Agreement with the buyer and enter its terms into the Term tab, Don`t hesitate to begin ' +
    'to use the Purchase tab to start measuring up prospective Replacement properties. it`s always good to think ahead! Once ' +
    'you are in contract, change Status dropdown to Inspection Period!'

  sale_inspection_period = -> 'Now you are in the process of Relinquishing your Property! Make sure that you have properly filled out ' +
    'all the Terms of the PSA especially the Date of the Contract and all relevant deadlines as in the payment of required ' +
    'deposits and -- most centrally importantly: <br/> <strong>THE DATE THAT THE INSPECTION PERIOD ENDS</strong><br/> ' +
    'Once that day passes, the Buyer can no longer get his or her money back. Also make sure to contact of Tenant to get an Estoppel ' +
    'Certificate or a waiver of the Right of First Refusal if such provisions exists in the contract. '

  sale_inspection_period_closing = -> '<strong>Congratulations!</strong> Now that the contract has `hardening`, the Buyer can ' +
    'no longer get his or her deposit money back! Now it`s time to work intensively in the Documents Tab to make sure that you have ' +
    'provided all necessary Documents to the Buyer and have acquired the necessary authorizations and corporate or entity documents ' +
    'from Buyer if necessary '

  sale_closing_date_set = -> '<strong>You are almost there!</strong> To get to this point, you must have filled out the Closing ' +
    'date in the Terms Tab. Now it`s time to fill out the Closing Statement and get it counter-signed by the other side. ' +
    'Make sure your buyer`s QI has the correct wire instructions for your Title Company! Also, as soon as the contract closes ' +
    ', update the Status Tab to Post Closing. Now your 45 days indentification and 180 days completion deadlines are ' +
    'ticking away. Can`t you hear the sound, tick tock, tick tock, tick tock ... '

  sale_post_closing = -> 'App enters Purchase Mode'

  try
    # if getJsonFromUrl()['status_alert'] == 'Sale+Pre+LOI'
    #   seller = $(document).find('input#entity_info').val()
    #   sweet_alert_text_success(sale_pre_loi_text(seller))
    # else if getJsonFromUrl()['status_alert'] == 'Sale+LOI+to+PSA'
    #   sweet_alert_text_success(sale_loi_to_psa())
    # else if getJsonFromUrl()['status_alert'] == 'Sale+Inspection+Period'
    #   sweet_alert_text_success(sale_inspection_period())
    # else if getJsonFromUrl()['status_alert'] == 'Sale+Inspection+Period+to+Closing'
    #   sweet_alert_text_success(sale_inspection_period_closing())
    # else if getJsonFromUrl()['status_alert'] == 'Sale+Closing+Date+Set'
    #   sweet_alert_text_success(sale_closing_date_set())
    # else if getJsonFromUrl()['status_alert'] == 'Sale+Post+Closing'
    #   sweet_alert_text_success(sale_post_closing())

  catch

  purchase_pre_loi_text = (purchaser) -> "<strong>Congratulations!</strong>  You have just initiated a 1031 Exchange
                            on behalf of " + purchaser + ". You can now identify the property
                            that you wish to purchase to replace the one that you relinquished,
                            Please be sure to input the contact info for your Qualified Intermediary, and
                            input the progress of your Exchange  by updating the Status dropdown.
                            All changes will be updated in the Status Tab"

  purchase_loi_to_psa = -> "<strong>Congratulations!</strong>  You have found a potential seller for a property
                          property that you wish to purchase to replace the one that you
                          relinquished.  Please fill out the Prospective Seller and use the Document tab to
                          create a compelling competitive Letter of Intent to entice this seller
                          into selling you this valuable property!  If the seller
                          accepts the terms of the LOI, negotiate a Purchase Sale Agreement
                          with the seller and enter its terms into the Terms tab.  Once
                          you are in contract, change Status dropdown to Inspection Period!"

  purchase_inspection_period = -> "Now you are in the process of Replacing your Relinquished Property!  Make sure
                                that you have properly filled out all the Terms of the PSA especially the
                                Date of the Contract and all relevant deadlines as in the payment of
                                required deposits and -- most centrally importantly :<br />
                                                <strong>THE DATE THAT THE INSPECTION PERIOD ENDS</strong>
                                <br />Once that day passes, you can no longer get your money back.  Go to the
                                Documents and Personnel Tabs and start hiring your Due Diligence Professionals.
                                Also make sure that the Seller contacts the Tenant to get an Estoppel Certificate
                                or a waiver of the Right of First Refusal if such a provision exists in the contract."

  purchase_inspection_period_closing = -> 'Well there’s no going back now, at least not without ditching your initial deposit!
                                        Now it’s time to work intensively in the Documents Tab and with your Title Insurance
                                        Company to make sure that you get as a clean a Title Insurance policy as possible.
                                        As soon as you have a Closing Date set with the Seller, fill it out in the Terms Tab and
                                        update the Status Tab to ‘Closing Date Set'

  purchase_closing_date_set = -> 'You are almost there!  To get to this point, you must have filled out the
                                Closing Date in the Terms Tab. Now it’s time to fill out the
                                Closing Statement and get it counter-signed by the other side.
                                Make sure your  QI has the correct wire instructions for your
                                Title Company and the Title Company has the correct wire
                                instructions for the Seller!  Also, as soon as the contract closes, update the Status
                                Tab to Post Closing.'

  try
    # if getJsonFromUrl()['status_alert'] == 'Purchase+Pre+LOI'
    #   purchaser = $(document).find('input#entity_info').val()
    #   sweet_alert_text_success(purchase_pre_loi_text(purchaser))
    # else if getJsonFromUrl()['status_alert'] == 'Purchase+LOI+to+PSA'
    #   sweet_alert_text_success(purchase_loi_to_psa())
    # else if getJsonFromUrl()['status_alert'] == 'Purchase+Inspection+Period'
    #   sweet_alert_text_success(purchase_inspection_period())
    # else if getJsonFromUrl()['status_alert'] == 'Purchase+Inspection+Period+to+Closing'
    #   sweet_alert_text_success(purchase_inspection_period_closing())
    # else if getJsonFromUrl()['status_alert'] == 'Purchase+Closing+Date+Set'
    #   sweet_alert_text_success(purchase_closing_date_set())

  catch


  $(document).on "click", "a.new-transaction", ->
    typewatch ->
      $(document).find("div#TransactionTypeList").show()
    , 10

  $(document).on "click", ".main_menu span.manual_delete_property", (e)->
    e.preventDefault()

    if $(this).parent().parent().hasClass('in-contract')
      if confirm('Please note: Since this property is in Contract, if Purchaser is really breaking contract, you may have various legal remedies.') == false
        return

    actionurl = '/transactions/delete_transaction_property?main_id=' + $(this).data('tran-mainid') + '&property_id=' + $(this).data('tran-propid') + '&type=' + $(this).data('tran-type')
    window.location.href = actionurl



  # --- Negotiations Step in Sale Wizard --- #

  # - Purchaser tab -
  $(document).on 'change', '#transaction_property_offer_relinquishing_purchaser_contact_id', ->
    if $(this).find('option:selected').text() == 'Add New'
      $(document).find('.relinquishing-purchaser-form-wrapper').show()
    else
      $(document).find('.relinquishing-purchaser-form-wrapper').hide()

  # - Offer and Acceptance -
  $(document).on 'click', '.nav-tabs #new_offer', (e)->
    e.preventDefault()
    elem = $(this)

    swalFunction = ->
      swal {
        title: 'Are you sure?'
        text: 'The 1st Accepted Offer has fallen through.'
        type: 'warning'
        showCancelButton: true
        cancelButtonText: "Close"
        confirmButtonColor: '#DD6B55'
        confirmButtonText: 'Delete the First Accepted Offer'
        closeOnConfirm: false
      }, (isConfirm)->
        if isConfirm
          console.log "1st Button"

          # Add new offer
          index = $('#offer_list').children().length

          $.ajax
            url: '/transaction_property_offers/'
            type: 'POST'
            dataType: 'json'
            data: { offer_name: 'Offeror ' + index, transaction_property_id: elem.data('tran-prop-id'), is_accepted: false }
            success: (data) ->
              if data.status
                elem.closest('li').before '<li><a data-toggle="tab" data-offer-id="' + data.offer_id + '" aria-expanded="true" href="#offer_' + data.offer_id + '_content">Offer '+ index + ' <span class="delete_offer fa fa-times"></span></a></li>'
                tabId = 'offer_' + data.offer_id + '_content'
                $('#offer_and_acceptance_section .tab-content').append '<div class="tab-pane" id="' + tabId + '">' + $('#offer_and_acceptance_template').html() + '</div>'
                $('#offer_list li:nth-child(' + index + ') a').click()

                initialize_editable_currency_field()
                initialize_editable_date_field()
                selected_offer_tab.find('.contact_is_company_false').iCheck
                  checkboxClass: 'icheckbox_flat-blue'
                  radioClass: 'iradio_flat-blue'
                selected_offer_tab.find('.contact_is_company_true').iCheck
                  checkboxClass: 'icheckbox_flat-blue'
                  radioClass: 'iradio_flat-blue'

                selected_offer_tab.find('input.cur_offer_id').val(data.offer_id)
                selected_offer_tab.find('.from_relinquishing_offeror').val(data.offer_id)
                selected_offer_tab.find('.relingquishing_offeror_form').attr('action', '/contacts/' + data.offeror_contact_id)

                if $(document).find('ul#offer_list li.done').length >= 1
                  selected_offer_tab.find('.initial_log_counteroffer').prop('disabled', 'disabled')
                  selected_offer_tab.find('.ask_accepted').prop('disabled', 'disabled')

                $.notify "Successfully added", "success"

                # Delete 1st offer
                $("#offer_list li").first().children('a').find("span.delete_offer").click()
              else
                $.notify "Failed", "error"
          swal.close()
        else
          console.log "3rd Button"
          $("#offer_list li").first().children('a').click()
          selected_offer_tab = $(document).find($("#offer_list li").first().children('a').attr('href'))
        return
      return

    swalExtend
      swalFunction: swalFunction
      hasCancelButton: true
      buttonNum: 1
      buttonNames: [
        'Leave and Proceed'
      ]
      clickFunctionList: [
        ->
          console.log '2th Button'

          index = $('#offer_list').children().length

          $.ajax
            url: '/transaction_property_offers/'
            type: 'POST'
            dataType: 'json'
            data: { offer_name: 'Offeror ' + index, transaction_property_id: elem.data('tran-prop-id'), is_accepted: false }
            success: (data) ->
              if data.status
                elem.closest('li').before '<li><a data-toggle="tab" data-offer-id="' + data.offer_id + '" aria-expanded="true" href="#offer_' + data.offer_id + '_content">Offer '+ index + ' <span class="delete_offer fa fa-times"></span></a></li>'
                tabId = 'offer_' + data.offer_id + '_content'
                $('#offer_and_acceptance_section .tab-content').append '<div class="tab-pane" id="' + tabId + '">' + $('#offer_and_acceptance_template').html() + '</div>'
                $('#offer_list li:nth-child(' + index + ') a').click()

                initialize_editable_currency_field()
                initialize_editable_date_field()
                selected_offer_tab.find('.contact_is_company_false').iCheck
                  checkboxClass: 'icheckbox_flat-blue'
                  radioClass: 'iradio_flat-blue'
                selected_offer_tab.find('.contact_is_company_true').iCheck
                  checkboxClass: 'icheckbox_flat-blue'
                  radioClass: 'iradio_flat-blue'

                selected_offer_tab.find('input.cur_offer_id').val(data.offer_id)
                selected_offer_tab.find('.from_relinquishing_offeror').val(data.offer_id)
                selected_offer_tab.find('.relingquishing_offeror_form').attr('action', '/contacts/' + data.offeror_contact_id)

                if $(document).find('ul#offer_list li.done').length >= 1
                  selected_offer_tab.find('.initial_log_counteroffer').prop('disabled', 'disabled')
                  selected_offer_tab.find('.ask_accepted').prop('disabled', 'disabled')

                $.notify "Successfully added", "success"

              else
                $.notify "Failed", "error"
          return
      ]

  $(document).on 'click', '#offer_list li span.delete_offer', (e)->
    anchor = $(this).parent('a')
    $.ajax
      url: '/transaction_property_offers/' + anchor.data('offer-id')
      type: 'DELETE'
      dataType: 'json'
      success: (data) ->
        if data
          $(anchor.attr('href')).remove()
          anchor.parent().remove()
          $("#offer_list li").children('a').first().click()
          $(document).find('.initial_log_counteroffer').prop('disabled', false)
          $(document).find('.ask_accepted').prop('disabled', false)

          $.notify "Successfully deleted", "success"
        else
          $.notify "Failed", "error"

  $(document).on 'ifChecked', '.contact_is_company_false', ->
    selected_offer_tab.find('.company-fields-wrapper').hide()
    selected_offer_tab.find('.company-fields-wrapper').find('input').val('')

    selected_offer_tab.find('.individual-fields-wrapper').show()
    selected_offer_tab.find('.individual-fields-wrapper').find('input').val('')

  $(document).on 'ifChecked', '.contact_is_company_true', ->
    selected_offer_tab.find('.company-fields-wrapper').show()
    selected_offer_tab.find('.company-fields-wrapper').find('input').val('')

    selected_offer_tab.find('.individual-fields-wrapper').hide()
    selected_offer_tab.find('.individual-fields-wrapper').find('input').val('')


  $("#offer_list li").first().children('a').click()
  selected_offer_tab = $(document).find($("#offer_list li").first().children('a').attr('href'))

  $("#basket_list li").first().children('a').click()
  selected_basket_tab = $(document).find($("#basket_list li").first().children('a').attr('href'))
  if selected_basket_tab.find('.is_identified_to_qi').val() == 'true'
      $(document).find('.is_selected_property').iCheck('disable')
    else
      $(document).find('.is_selected_property').iCheck('enable')


  initialize_editable_date_field = ->
    $(document).find('.editable-date').editable
      combodate: { maxYear: 2030, minYear: 2000 },
      emptytext: 'Enter Date'
      template: 'MMM / D / YYYY'
      validate: (value) ->
        prev_counteroffer_date = $(this).parent().parent().prev().children().first().find('span.editable-date').data('value')
        if prev_counteroffer_date > value.format('YYYY-MM-DD')
          return 'Please select later date than previous counteroffer'
      success: (response) ->
        if response.counteroffer.offered_date && response.counteroffer.offered_price
          if last_counteroffer  == "Client"
            selected_offer_tab.find('.add_counteroffer').text('Buyer Counter')
            if $(document).find('#negotiations_wrapper').data('transaction-type') == 'sale'
              selected_offer_tab.find('.btn_accept_counteroffer').text('Counter Accepted')
            else
              selected_offer_tab.find('.btn_accept_counteroffer').text('Accept Counter')
          else
            if $(document).find('#negotiations_wrapper').data('transaction-type') == 'sale'
              selected_offer_tab.find('.add_counteroffer').text('Client Counter')
              selected_offer_tab.find('.btn_accept_counteroffer').text('Accept Counter')
            else
              selected_offer_tab.find('.add_counteroffer').text('Seller Counter')
              selected_offer_tab.find('.btn_accept_counteroffer').text('Counter Accepted')

          selected_offer_tab.find('.counteroffer_action_buttons_wrapper').show()
          selected_offer_tab.find('.add_counteroffer').attr("disabled", false)
          selected_offer_tab.find('.last_counteroffer_price').val('$' + parseFloat(response.counteroffer.offered_price).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))

          if selected_offer_tab.find('.counteroffer_history tr').length > 1
            selected_offer_tab.find('.btn_accept_counteroffer').attr('disabled', false)
            selected_offer_tab.find('.ask_accepted').hide()


  initialize_editable_date_field()

  initialize_editable_currency_field = ->
    $(document).find('.editable-currency').editable
      type: 'text',
      tpl: '<input class="offered-price" type="text">',
      params: (params) ->
        params.value = $(document).find('input.offered-price').inputmask('unmaskedvalue')
        return params
      emptytext: 'Enter Amount of Offer'
      success: (response) ->
        if response.counteroffer.offered_date && response.counteroffer.offered_price
          if last_counteroffer  == "Client"
            selected_offer_tab.find('.add_counteroffer').text('Buyer Counter')
            if $(document).find('#negotiations_wrapper').data('transaction-type') == 'sale'
              selected_offer_tab.find('.btn_accept_counteroffer').text('Counter Accepted')
            else
              selected_offer_tab.find('.btn_accept_counteroffer').text('Accept Counter')
          else
            if $(document).find('#negotiations_wrapper').data('transaction-type') == 'sale'
              selected_offer_tab.find('.add_counteroffer').text('Client Counter')
              selected_offer_tab.find('.btn_accept_counteroffer').text('Accept Counter')
            else
              selected_offer_tab.find('.add_counteroffer').text('Seller Counter')
              selected_offer_tab.find('.btn_accept_counteroffer').text('Counter Accepted')

          selected_offer_tab.find('.counteroffer_action_buttons_wrapper').show()
          selected_offer_tab.find('.add_counteroffer').attr("disabled", false)
          selected_offer_tab.find('.last_counteroffer_price').val('$' + parseFloat(response.counteroffer.offered_price).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))

          if selected_offer_tab.find('.counteroffer_history tr').length > 1
            selected_offer_tab.find('.btn_accept_counteroffer').attr('disabled', false)
            selected_offer_tab.find('.ask_accepted').hide()


  initialize_editable_currency_field()

  $(document).on "focus", "input.offered-price", ->
    $(this).inputmask
      alias: 'currency'
      rightAlign: false
      prefix: '$ '
      removeMaskOnSubmit: true
      positionCaretOnTab: true

  $(document).on 'click', '#sale_buy_step_tab li a', (e)->
    if $(this).attr('id') == 'purchase_sale_agreement'
      if $(document).find('#letter_of_intent_section .is_passed').val() == 'false'
        # sweetAlert('', not_passed_LOI, 'warning')

        swalFunction = ->
          swal {
            title: 'Are you sure?'
            text: not_passed_LOI
            type: 'warning'
            showCancelButton: true
            cancelButtonText: "Close"
            confirmButtonColor: '#DD6B55'
            confirmButtonText: 'Skip LOI and Next'
            closeOnConfirm: false
          }, (isConfirm)->
            if isConfirm
              console.log "Save Button"
              swal.close()
            else
              console.log "Close Button"
            return
          return

        swalExtend
          swalFunction: swalFunction
          hasCancelButton: true
          buttonNum: 1
          buttonNames: [
            'Back'
          ]
          clickFunctionList: [
            ->
              console.log 'Back Button'
              $('#letter_of_intent').click()
              return
          ]

    selected_transaction_sub_tab = $(document).find($(this).attr('href'))
    curPropertyId = $("#cur_property_id").val()
    selectedTabId = $(this).attr("id")

    if !isNaN(parseInt(curPropertyId)) && parseInt(curPropertyId) > 0
      $.ajax
        type: "POST"
        url: "/xhr/save_transaction_subtab"
        data: {id: curPropertyId, subtab: selectedTabId}
        dataType: "json"
        success: (val) ->
          console.log val
        error: (e) ->
          console.log e

  $(document).on 'click', '#offer_list li a', (e)->
    if $(this).attr("id") != 'new_offer'
      selected_offer_tab = $(document).find($(this).attr('href'))

  $(document).on 'click', '#basket_list li a', (e)->
    if $(document).find('#basket_list li.identified').length > 0
      console.log 'frozen basket'
      $(document).find('.is_selected_property').iCheck('disable')
      if !$(this).parent('li').hasClass('identified')
        sweetAlert '', 'One basket already Identified', 'info'
        setTimeout (->
            $(document).find('#basket_list li.saved.identified a').click()
        ), 100
        return
    else
      $(document).find('.is_selected_property').iCheck('enable')

    selected_basket_tab = $(document).find($(this).attr('href'))



  $(document).on 'change', '.relingquishing_offeror_form input', ->
    if selected_offer_tab.find('.relingquishing_offeror_form').attr('action') != ""
      action_url = selected_offer_tab.find('.relingquishing_offeror_form').attr('action')
      type = 'PUT'
    else
      action_url = '/contacts/'
      type = 'POST'

    $.ajax
      url: action_url
      type: type
      dataType: 'json'
      data: selected_offer_tab.find('.relingquishing_offeror_form').serialize()
      success: (data) ->
        if data
          selected_offer_tab.find('.relingquishing_offeror_form').attr('action', '/contacts/' + data.id)
          if !data.is_company
            $(document).find('#offer_list li.active a').text(data.first_name)
          else
            $(document).find('#offer_list li.active a').text(data.company_name)
        else
          $.notify "Failed!", "error"

  add_counteroffer_row = (offer_id, date, offeror, price) ->
    date = date || moment().format('YYYY-MM-DD')
    if price != ""
      unformated_price = Number(price.replace(/[^0-9\.]+/g, ""))
    else
       unformated_price = ""

    $.ajax
      url: '/counteroffers/'
      type: 'POST'
      dataType: 'json'
      data: { transaction_property_offer_id: offer_id, offer_type: offeror, offered_date: date, offered_price: unformated_price }
      success: (data) ->
        if data.status
          table_cell_offeror = offeror
          if $(document).find('#negotiations_wrapper').data('transaction-type') == 'purchase'
            if table_cell_offeror == 'Client'
              table_cell_offeror = 'Seller'
            else
              table_cell_offeror = 'Client'

          add_row_html = '<tr data-counteroffer-id="' + data.counteroffer_id + '">
                            <td width="150">
                                <span class="editable-date" data-name="offered_date" data-url="/counteroffers/' + data.counteroffer_id + '" data-type="combodate" data-value="' + date + '" data-format="YYYY-MM-DD" data-viewformat="MM/DD/YYYY"></span>
                            </td>
                            <td width="300">
                                <span>' + table_cell_offeror + '</span>
                            </td>
                            <td width="300">
                                <span class="green editable-currency" data-name="offered_price" data-type="text" data-url="/counteroffers/' + data.counteroffer_id + '" data-value="' + price + '"></span>
                            </td>
                            <td>
                                <a href="javascript:;" class="delete_counteroffer btn btn-danger btn-xs"><i class="fa fa-trash-o"></i></a>
                            </td>
                        </tr>'

          selected_offer_tab.find('.counteroffer_history tr.last_row').before(add_row_html)
          initialize_editable_currency_field()
          initialize_editable_date_field()
          selected_offer_tab.find('.add_counteroffer').attr("disabled", "disabled")
          $.notify "Successfully updated", "success"
        else
          $.notify "Failed", "error"


  $(document).on 'click', '.initial_log_counteroffer', (e) ->
    e.preventDefault()
    add_counteroffer_row(selected_offer_tab.find('input.cur_offer_id').val(), "", "Counter-Party", "")
    last_counteroffer = "Counter-Party"
    $(this).hide()
    selected_offer_tab.find('.ask_accepted').hide()

  $(document).on 'click', '.ask_accepted', (e) ->
    e.preventDefault()
    tab_element = $(document).find('#offer_list li.active a')
    selected_offer_tab.find('.last_counteroffer_price').val(selected_offer_tab.find('.property-price').text())
    accept_counteroffer(tab_element.data('offer-id'))


  $(document).on "click", ".add_counteroffer", (e) ->
    e.preventDefault()
    last_counteroffer = if last_counteroffer == "" then selected_offer_tab.find('.last_counteroffer').val() else last_counteroffer
    if last_counteroffer == "Client"
      add_counteroffer_row(selected_offer_tab.find('input.cur_offer_id').val(), "", "Counter-Party", "")
      last_counteroffer = "Counter-Party"
    else
      add_counteroffer_row(selected_offer_tab.find('input.cur_offer_id').val(), "", "Client", "")
      last_counteroffer = "Client"

  $(document).on 'click', '.delete_counteroffer', (e)->
    table_tr = $(this).parent().parent('tr')
    last_counteroffer = if last_counteroffer == "" then selected_offer_tab.find('.last_counteroffer').val() else last_counteroffer
    $.ajax
      url: '/counteroffers/' + table_tr.data('counteroffer-id')
      type: 'DELETE'
      dataType: 'json'
      success: (data) ->
        if data
          selected_offer_tab.find('.last_counteroffer_price').val(table_tr.prev().children().find('span.editable-currency').text())
          table_tr.remove()
          if last_counteroffer == 'Client'
            last_counteroffer = 'Counter-Party'
            if $(document).find('#negotiations_wrapper').data('transaction-type') == 'sale'
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper .add_counteroffer').text('Client Counter')
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper .btn_accept_counteroffer').text('Accept Counter')
            else
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper .add_counteroffer').text('Seller Counter')
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper .btn_accept_counteroffer').text('Counter Accepted')
          else
            last_counteroffer = 'Client'
            if $(document).find('#negotiations_wrapper').data('transaction-type') == 'sale'
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper .add_counteroffer').text('Buyer Counter')
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper .btn_accept_counteroffer').text('Counter Accepted')
            else
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper .add_counteroffer').text('Buyer Counter')
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper .btn_accept_counteroffer').text('Accept Counter')

          if selected_offer_tab.find('.counteroffer_history tr').length == 1
            selected_offer_tab.find('.initial_log_counteroffer').show()
            selected_offer_tab.find('.ask_accepted').show()
            if $(document).find('#negotiations_wrapper').data('transaction-type') == 'sale'
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper').hide()
            else
              selected_offer_tab.find('.counteroffer_action_buttons_wrapper .btn_accept_counteroffer').attr('disabled', 'disabled')

          selected_offer_tab.find('.add_counteroffer').attr('disabled', false)
          $.notify "Successfully deleted", "success"
        else
          $.notify "Failed", "error"


  # Click Accept offer
  $(document).on "click", ".btn_accept_counteroffer", (e) ->
    e.preventDefault()
    tab_element = $(document).find('#offer_list li.active a')
    accepted_counteroffer_id = selected_offer_tab.find('table.counteroffer_history tr.last_row').prev().data('counteroffer-id')
    accept_counteroffer(tab_element.data('offer-id'), accepted_counteroffer_id )

  accept_counteroffer = (offer_id, accepted_counteroffer_id = 0) ->
    $.ajax
      url: '/transaction_property_offers/' + offer_id
      type: 'PUT'
      dataType: 'json'
      data: { is_accepted: true, accepted_counteroffer_id: accepted_counteroffer_id }
      success: (data) ->
        if data.status
          $.notify "Counter Accepted", "success"

          last_counteroffer = last_counteroffer || selected_offer_tab.find('.last_counteroffer').val()
          if last_counteroffer == 'Client'
            selected_offer_tab.find('.btn_accept_counteroffer').text('Client\'s Counter Accepted')
          else if last_counteroffer == 'Counter-Party'
            selected_offer_tab.find('.btn_accept_counteroffer').text('Buyer\'s Counter Accepted')
          else
            selected_offer_tab.find('.btn_accept_counteroffer').text('Ask Accepted')
            selected_offer_tab.find('.counteroffer_action_buttons_wrapper').show()

          selected_offer_tab.find('.asking_description').text($(document).find('#relinquishing_seller_name').val() + ' and ' + data.offer_name + ' have agreed to the price of')
          selected_offer_tab.find('.relingquishing_offeror_form').hide()

          selected_offer_tab.find('.btn_accept_counteroffer').attr('disabled', 'disabled')
          selected_offer_tab.find('.add_counteroffer').attr('disabled', 'disabled')
                                                      .hide()
          selected_offer_tab.find('.initial_log_counteroffer').attr('disabled', 'disabled')
                                                              .hide()
          selected_offer_tab.find('.ask_accepted').attr('disabled', 'disabled')
                                                  .hide()
          if $(document).find('#negotiations_wrapper').data('transaction-type') == 'purchase'
            $(document).find('#offer_list li.active a').html('<i class="red">Accepted</i>')

          $(document).find('#relinquishing_property_sale_price').val(selected_offer_tab.find('.last_counteroffer_price').val())

          loi_description = data.offer_name + ' is purchasing ' + $(document).find('#negotiated_property').val() + ' for ' + selected_offer_tab.find('.last_counteroffer_price').val()
          $(document).find('#loi_description').text(loi_description)
          $(document).find('#loi_description').show()

          accepted_price = Number(selected_offer_tab.find('.last_counteroffer_price').val().replace(/[^0-9\.]+/g,""))
          current_rent = Number($(document).find('#relinquishing_property_current_rent').val().replace(/[^0-9\.]+/g,""))
          if accepted_price != 0
            $(document).find('#relinquishing_property_rat_race').val((current_rent * 100 / accepted_price).toFixed(2))
          else
            $(document).find('#relinquishing_property_rat_race').val('')

          # $('#sale_buy_step_tab a#letter_of_intent').click()
          window.location.reload()
        else
          $.notify "Failed", "error"

  #- LOI(Letter of Intent)  -#

  # Enable 2nd Deposit
  $(document).on 'ifChanged', '#enable-2nd-deposit', ->
    if this.checked
      $(this).parents().parent().parent().find('.right .form-control').prop( "disabled", false )
      $(this).parent().siblings('.vertical-line').css({"border-color": "#3082ee"})
    else
      $(this).parent().parent().parent().find('.right .form-control').prop( "disabled", "disabled" )
      $(this).parent().siblings('.vertical-line').css({"border-color": '#777'})

  $(document).on 'click', (e) ->
    container = $("div#TransactionTypeList")
    if (!container.is(e.target) && (container.has(e.target).length == 0))
      container.hide()

  $(document).on 'nested:fieldAdded', (event) ->
    field = event.field
    $(document).find(field.find('.input-mask-currency')).inputmask
      alias: 'currency',
      rightAlign: false,
      prefix: ''

  $(document).on 'ajax:success', '.transaction_property_inspection_form', (e, data, status, xhr) ->
    if $('#sale_buy_step_tab li.active').nextAll().length >= 1
      $('#sale_buy_step_tab li.active').next().find('a').click()
    else
      next_step = $(document).find('ul.wizard_steps li.selected').next()
      window.location.href = next_step.find('a').attr("href")



  $(document).on 'ajax:success', '.transaction_property_term_form', (e, data, status, xhr) ->
    $.notify 'Success', 'success'
    if data.psa_date
      psa_date = new Date(data.psa_date)
      $(document).find('.side-menu>li>.nav.child_menu>li.current-page').addClass('in-contract')
    else
      $(document).find('#letter_of_intent_section .is_passed').val(true)
      psa_date = new Date()

    console.log psa_date
    set_first_deposit_date_due(psa_date, data.first_deposit_days_after_psa)
    $(document).find('#transaction_transaction_term_attributes_first_deposit_days_after_psa').val(data.first_deposit_days_after_psa)

    set_inspection_period_end(psa_date, data.inspection_period_days)
    $(document).find('#transaction_transaction_term_attributes_inspection_period_days').val(data.inspection_period_days)

    set_second_deposit_date_due(psa_date, data.second_deposit_days_after_inspection_period)
    $(document).find('#transaction_transaction_term_attributes_second_deposit_days_after_inspection_period').val(data.second_deposit_days_after_inspection_period)
    if (data.second_deposit)
      $(document).find('.transaction_transaction_term_attributes_second_deposit_wrapper').show()
    else
      $(document).find('.transaction_transaction_term_attributes_second_deposit_wrapper').hide()
      $(document).find('.transaction_transaction_term_attributes_second_deposit_wrapper select').prop('disabled', 'disabled')

    set_closing_date(psa_date, data.closing_days_after_inspection_period)
    $(document).find('#transaction_transaction_term_attributes_closing_days_after_inspection_period').val(data.closing_days_after_inspection_period)

    if $('#sale_buy_step_tab li.active').nextAll().length >= 1
      $('#sale_buy_step_tab li.active').next().find('a').click()
    else
      next_step = $(document).find('ul.wizard_steps li.selected').next()
      window.location.href = next_step.find('a').attr("href")

  $(document).on 'click', '.back_prev_step', (e) ->
    e.preventDefault()
    $('#sale_buy_step_tab li.active').prev().find('a').click()

  # Show modal for submenu of top menu
  $(document).on 'click', '.top-header ul li a > span', (e)->
    e.preventDefault()
    if($(this).attr('id') == 'add-client')
      $.ajax
        type: "POST"
        url: "/xhr/entity_type_list?design_with_labels=1"
        dataType: "html"
        success: (val) ->
          $(document).find("#md-add-client .modal-body").html(val)
        error: (e) ->
          console.log e

    modal_id = '#md-' + $(this).attr('id')
    $(modal_id).modal()

  #- Purcahse Sale Agreement -#
  dateFormatYMD = (date)->
    des_dt = new Date(date)
    date_string = ""
    date_string += des_dt.getFullYear() + '-'
    if des_dt.getMonth() + 1 < 10
      date_string += '0' + (des_dt.getMonth() + 1)
    else
      date_string += (des_dt.getMonth() + 1)
    date_string += '-'
    if des_dt.getDate() < 10
      date_string += '0' + des_dt.getDate()
    else
      date_string += des_dt.getDate()

    return date_string

  set_first_deposit_date_due = (psa_date, offset = 0) ->
    first_deposit_date_due = new Date(psa_date)
    first_deposit_date_due.setDate(first_deposit_date_due.getDate() + parseInt(offset))
    $(document).find('#transaction_transaction_term_attributes_first_deposit_date_due_1i').val(first_deposit_date_due.getFullYear())
    $(document).find('#transaction_transaction_term_attributes_first_deposit_date_due_2i').val(first_deposit_date_due.getMonth() + 1)
    $(document).find('#transaction_transaction_term_attributes_first_deposit_date_due_3i').val(first_deposit_date_due.getDate())

    $(document).find('#transaction_transaction_term_attributes_first_deposit_date_due').val(dateFormatYMD(first_deposit_date_due))

  set_inspection_period_end = (psa_date, offset = 0) ->
    inspection_period_end = new Date(psa_date)
    inspection_period_end.setDate(inspection_period_end.getDate() + parseInt(offset))
    $(document).find('#transaction_transaction_term_attributes_inspection_period_end_1i').val(inspection_period_end.getFullYear())
    $(document).find('#transaction_transaction_term_attributes_inspection_period_end_2i').val(inspection_period_end.getMonth() + 1)
    $(document).find('#transaction_transaction_term_attributes_inspection_period_end_3i').val(inspection_period_end.getDate())


  set_second_deposit_date_due = (psa_date, offset = 0) ->
    second_deposit_date_due = new Date(psa_date)
    second_deposit_date_due.setDate(second_deposit_date_due.getDate() + parseInt(offset))
    $(document).find('#transaction_transaction_term_attributes_second_deposit_date_due_1i').val(second_deposit_date_due.getFullYear())
    $(document).find('#transaction_transaction_term_attributes_second_deposit_date_due_2i').val(second_deposit_date_due.getMonth() + 1)
    $(document).find('#transaction_transaction_term_attributes_second_deposit_date_due_3i').val(second_deposit_date_due.getDate())

    $(document).find('#transaction_transaction_term_attributes_second_deposit_date_due').val(dateFormatYMD(second_deposit_date_due))

  set_closing_date = (psa_date, offset = 0 )->
    closing_date = new Date(psa_date)
    closing_date.setDate(closing_date.getDate() + parseInt(offset))
    $(document).find('#transaction_transaction_term_attributes_closing_date_1i').val(closing_date.getFullYear())
    $(document).find('#transaction_transaction_term_attributes_closing_date_2i').val(closing_date.getMonth() + 1)
    $(document).find('#transaction_transaction_term_attributes_closing_date_3i').val(closing_date.getDate())

    $(document).find('#transaction_transaction_term_attributes_closing_date').val(dateFormatYMD(closing_date))

  $(document).on 'change', '.transaction_transaction_term_attributes_psa_date', ()->
    psa_year = $(document).find('#transaction_transaction_term_attributes_psa_date_1i option:selected').val()
    psa_month = $(document).find('#transaction_transaction_term_attributes_psa_date_2i option:selected').val()
    psa_day = $(document).find('#transaction_transaction_term_attributes_psa_date_3i option:selected').val()
    psa_date = new Date(parseInt(psa_year), parseInt(psa_month) - 1, parseInt(psa_day))

    first_deposit_days_after_psa = $(document).find('#transaction_transaction_term_attributes_first_deposit_days_after_psa').val() || 0
    set_first_deposit_date_due(psa_date, first_deposit_days_after_psa)

    inspection_period_days = $(document).find('#transaction_transaction_term_attributes_inspection_period_days').val() || 0
    set_inspection_period_end(psa_date, inspection_period_days)

    second_deposit_days_after_inspection_period = $(document).find('#transaction_transaction_term_attributes_second_deposit_days_after_inspection_period').val() || 0
    set_second_deposit_date_due(psa_date, second_deposit_days_after_inspection_period)

    closing_days_after_inspection_period = $(document).find('#transaction_transaction_term_attributes_closing_days_after_inspection_period').val() || 0
    set_closing_date(psa_date, closing_days_after_inspection_period)

  $(document).on 'change', 'input.manually_date_on_psa', ->
    select_object = $(document).find("select.#{$(this).data('class')}")

    if this.checked
      select_object.prop('disabled', false)
    else
      select_object.prop('disabled', 'disabled')

#-- End of Alex's code --#


  # Prevent edit transaction form submit on enter
  $(document).on 'keyup keypress', 'form.transaction-photo-gallery', (e)->
    keyCode = e.keyCode || e.which
    if keyCode == 13
      e.preventDefault()
      return false

  # Edit transaction form validation check
  $("form.transaction-photo-gallery").on 'click', 'input[type=submit]', (e)->
    resultValidation = true
    checkedElement = false

    $.each $("form.transaction-photo-gallery").find('.is_selected_property'), ->
      if $(this).is(":checked")
        checkedElement = true
        if $(this).parents(".fields").find('.property_with_no_tenant').val() == "false"
          if $(this).parents(".fields").find(".cap-rate-box input").val() == "" || $(this).parents(".fields").find(".price-box input").val() == ""
            resultValidation = false
            $(this).parents(".fields").find(".transaction-form-validation").show()
        else
          if $(this).parents(".fields").find(".price-box input").val() == "" || parseFloat($(this).parents(".fields").find(".price-box input").val()) == 0
            resultValidation = false
            $(this).parents(".fields").find(".transaction-form-validation").show()

    if resultValidation == false || checkedElement == false
      e.preventDefault()
      return false

  $("form.transaction-photo-gallery").on 'keydown', '.cap-rate-box input', (e)->
    $(this).closest('.fields').find('.is_selected_property').iCheck('check')
    $(this).parents(".fields").find(".transaction-form-validation").hide()

  $("form.transaction-photo-gallery").on 'keydown', '.price-box input', (e)->
    $(this).parents(".fields").find(".transaction-form-validation").hide()

  $.each $(document).find('.is_selected_property'), ->
    if !$(this).is(":checked")
      $(this).parents(".fields").addClass('property-unchecked')

  checkShowButton = ->
    flgShowButton = false
    if $(".transaction-photo-gallery").length == 0 && $(".sale-step1-form").length == 0
      flgShowButton = true
    $.each $(document).find('.is_selected_property'), ->
      if $(this).is(":checked")
        flgShowButton = true
    if flgShowButton == false
      $("#save-and-next").hide()
      $(".transaction-photo-gallery input[type=submit]").hide()
    else
      $("#save-and-next").show()
      $(".transaction-photo-gallery input[type=submit]").show()
  checkShowButton()

  #--- Created by DeskStar ---
  $(document).on 'change', 'select#transaction_identification_rule', ->
    switch $(this).val()
      when 'three_property'
        selected_basket_tab.find('section#200_percent_measure').show()
        selected_basket_tab.find('section#95_percent_measure').hide()
        selected_basket_tab.find('section#200_percent_measure .toolbar-btn-action').hide()
        selected_basket_tab.find('.basket_property_table tbody tr .input-mask-currency').attr('disabled', false)
        selected_basket_tab.find('.basket_property_table tbody tr .go_to_negotiations').attr('disabled', false)
        
        if selected_basket_tab.find('.basket_property_table tbody tr').length > 3
          deselect_property_count = selected_basket_tab.find('.basket_property_table tbody tr').length - 3
          over_3_properties_warning = "You can select only 3 properties. Please deselect " + deselect_property_count + " properties on this basket"
          sweetAlert("", over_3_properties_warning, "warning")
          selected_basket_tab.find('.basket_property_table tbody tr td .go_to_negotiations').attr('disabled','disabled')
          
      when '200_percent'
        selected_basket_tab.find('section#200_percent_measure').show()
        selected_basket_tab.find('section#95_percent_measure').hide()
        selected_basket_tab.find('section#200_percent_measure .toolbar-btn-action').show()
        selected_basket_tab.find('.basket_property_table tbody tr .input-mask-currency').attr('disabled', 'disabled')
        selected_basket_tab.find('.basket_property_table tbody tr .go_to_negotiations').attr('disabled', 'disabled')
        selected_basket_tab.find('.save_next_in_step').attr('disabled', 'disabled')
                                                      .addClass('hidden')
      when '95_percent'
        selected_basket_tab.find('section#200_percent_measure').hide()
        selected_basket_tab.find('section#95_percent_measure').show()
        $(document).find('.save_next_in_step').attr('disabled', false)
                                                      .removeClass('hidden')
        sweetAlert '', percent_95_warning, 'warning'

  $(document).on 'ifChanged', '.is_selected_property', ->
    el = $(this)
    if this.checked
      $(this).parents(".fields").removeClass('property-unchecked')
      if $(document).find('#global_transaction_type').val() == 'purchase'
        selected_property_count = selected_basket_tab.find('.basket_property_table tbody tr').length
        console.log selected_property_count
        if selected_basket_tab.find('#transaction_identification_rule').val() == 'three_property'
          if selected_property_count > 2
            setTimeout (->
              el.iCheck('uncheck')

            ), 10
            sweetAlert("", alert_for_three_property_rule, "warning")
            return
        if selected_basket_tab.find('#transaction_identification_rule').val() == '95_percent'
          add_property_to_identification($(this).parents(".fields"))
        else
          add_property_to_identification($(this).parents(".fields"))
          if selected_basket_tab.find('.disable_editing_property').val() != "true"
            add_property_to_basket($(this).parents(".fields"))
      
    else
      $(this).parents(".fields").addClass('property-unchecked')
      if $(document).find('#global_transaction_type').val() == 'purchase'
        if selected_basket_tab.find('.disable_editing_property').val() != "true"
          delete_property_on_basket($(this).parents(".fields"))
        delete_property_on_identification($(this).parents(".fields"))

    checkShowButton()

  calculate_purchase_costs = ->
    purchase_cost_in_contract = 0
    purchase_cost_in_contract_selected = 0
    selected_basket_tab.find('.basket_property_table tbody tr').each ->
      if $(this).find('td').eq(1).text() == 'Closed'
        # Nothing yet
      else if $(this).find('td').eq(1).text() == 'In Contract'
        purchase_cost_in_contract += parseInt($(this).find('td .counter-price').val().replace(/\,/g, '') || 0)
        purchase_cost_in_contract_selected += parseFloat($(this).find('td .counter-price').val().replace(/\,/g, '') || 0)
      else
        purchase_cost_in_contract_selected += parseFloat($(this).find('td .counter-price').val().replace(/\,/g, '') || 0)

    selected_basket_tab.find('.purchase_property_cost_table tr:first-child td span.orange').text('$' + purchase_cost_in_contract.toFixed(2).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))
    selected_basket_tab.find('.purchase_property_cost_table tr:first-child td span.green').text('$' + purchase_cost_in_contract_selected.toFixed(2).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))

    est_identification_budget1 = parseFloat(selected_basket_tab.find('.identification_budget_table tr:first-child td').eq(0).data('closed_total_price'))
    est_identification_budget2 = parseFloat(selected_basket_tab.find('.identification_budget_table tr:first-child td').eq(1).data('closed_contract_total_price'))
    est_identification_budget3 = parseFloat(selected_basket_tab.find('.identification_budget_table tr:first-child td').eq(2).data('closed_contract_asking_total_price'))
    selected_basket_tab.find('.underage_or_overage_table tr td:nth-child(1) span.red').text('$' + (est_identification_budget1 - purchase_cost_in_contract).toFixed(2).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' | ')
    selected_basket_tab.find('.underage_or_overage_table tr td:nth-child(1) span.orange').text('$' + (est_identification_budget2 - purchase_cost_in_contract).toFixed(2).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' | ')
    selected_basket_tab.find('.underage_or_overage_table tr td:nth-child(1) span.green').text('$' + (est_identification_budget3 - purchase_cost_in_contract).toFixed(2).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))

    selected_basket_tab.find('.underage_or_overage_table tr td:nth-child(2) span.red').text('$' + (est_identification_budget1 - purchase_cost_in_contract_selected).toFixed(2).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' | ')
    selected_basket_tab.find('.underage_or_overage_table tr td:nth-child(2) span.orange').text('$' + (est_identification_budget2 - purchase_cost_in_contract_selected).toFixed(2).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' | ')
    selected_basket_tab.find('.underage_or_overage_table tr td:nth-child(2) span.green').text('$' + (est_identification_budget3 - purchase_cost_in_contract_selected).toFixed(2).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))

  add_property_to_identification = (selected_property)->
    row_id = 'property_' + selected_property.find('.transaction-property-select input[type=hidden]').val()
    add_row_html = '<tr id="' + row_id + '">
                      <td>
                          <span class="green">' + selected_property.find('.transaction-property-select h3').text() + '</span>
                      </td>
                      <td class="current-rent">
                          $' + selected_property.find('.transaction-property-calculation-readonly .current-rent').val() + '
                      </td>
                      <td class="cap-rate">' + selected_property.find('.transaction-property-calculation-readonly .current-cap-rate').val() + '</td>
                      <td data-property_price="' + selected_property.find('.transaction-property-calculation-readonly .current-price').val().replace(/\,/g, '') + '">
                        $' + selected_property.find('.transaction-property-calculation-readonly .current-price').val() +
                      '</td>
                      <td>
                          <input type="text" class="counter-cap-rate input-mask-currency" value="' + selected_property.find('.transaction-property-calculation-readonly .current-cap-rate').val() + '" />
                      </td>
                      <td>
                          $ <input type="text" class="counter-price input-mask-currency" value="' + selected_property.find('.transaction-property-calculation-readonly .current-price').val().replace(/\,/g, '') + '" />
                      </td>
                    </tr>'
    selected_basket_tab.find('.property_identification_table tbody').append(add_row_html)
    selected_basket_tab.find('.property_identification_table .input-mask-currency').inputmask
      alias: 'currency',
      rightAlign: false,
      prefix: ''

  add_property_to_basket = (selected_property)->
    row_id = 'property_' + selected_property.find('.transaction-property-select input[type=hidden]').val()
    if selected_basket_tab.find('#transaction_identification_rule').val() == 'three_property'
      disable_proceed_button = ''
      disable_input_mask = ''
    else
      disable_proceed_button = 'disabled'
      disable_input_mask = 'disabled'
    if selected_basket_tab.find('.basket_property_table tbody tr#' + row_id).length == 0
      add_row_html = '<tr id="' + row_id + '" data-property_id="' + selected_property.find('.transaction-property-select input[type=hidden]').val() + '">
                        <td class="text-center">
                            <a href="javascript:;"><span class="remove_property_from_basket lnr lnr-cross"></span></a>
                        </td>
                        <td>
                            <span class="label label-success"></span>
                        </td>
                        <td>
                            <span class="green">' + selected_property.find('.transaction-property-select h3').text() + '</span>
                        </td>
                        <td class="current-rent">
                            $' + selected_property.find('.transaction-property-calculation-readonly .current-rent').val() + '
                        </td>
                        <td class="cap-rate">' + selected_property.find('.transaction-property-calculation-readonly .current-cap-rate').val() + '</td>
                        <td data-property_price="' + selected_property.find('.transaction-property-calculation-readonly .current-price').val().replace(/\,/g, '') + '">
                          $' + selected_property.find('.transaction-property-calculation-readonly .current-price').val() +
                        '</td>
                        <td>
                            <input type="text" class="counter-cap-rate input-mask-currency" value="' + selected_property.find('.transaction-property-calculation-readonly .current-cap-rate').val() + '" ' + disable_input_mask + ' />
                        </td>
                        <td>
                            $ <input type="text" class="counter-price input-mask-currency" value="' + selected_property.find('.transaction-property-calculation-readonly .current-price').val().replace(/\,/g, '') + '" ' + disable_input_mask + ' />
                        </td>
                        <td>
                            <a href="javascript:;" class="go_to_negotiations btn btn-danger btn-sm" ' + disable_proceed_button + '>Accept and Proceed</a>
                        </td>
                    </tr>'

      selected_basket_tab.find('.basket_property_table tbody').append(add_row_html)

      $(document).find('.basket_property_table .input-mask-currency').inputmask
        alias: 'currency',
        rightAlign: false,
        prefix: ''

      calculate_purchase_costs()

  delete_property_on_identification = (selected_property)->
    $('.property_identification_table tbody tr#property_' + selected_property.find('.transaction-property-select input[type=hidden]').val()).remove()

  delete_property_on_basket = (selected_property)->
    $('.basket_property_table tbody tr#property_' + selected_property.find('.transaction-property-select input[type=hidden]').val()).remove()
  
  set_attr_after_identify = ->
    selected_basket_tab.find('.save_identify_this_basket_to_qi').hide()
    $(document).find('#properties_identification .tab-content .save_identify_this_basket_to_qi').attr('disabled', 'disabled')
    $(document).find('.basket_property_table tbody tr td .go_to_negotiations').attr('disabled', false)

    $(document).find('#basket_list li.active').addClass('identified')
    $('#basket_list li.active a i').text('Identified')
    selected_basket_tab.find('.is_identified_to_qi').val("true")
    
    $(document).find('.is_selected_property').iCheck('disable')

  create_new_basket = (basket_index)->
    $('#basket_list li').last().after '<li><a data-toggle="tab" aria-expanded="true" href="#basket_' + basket_index + '_section"><i>Basket '+ basket_index + ' </i></a></li>'
    tabId = 'basket_' + basket_index + '_section'
    $('#properties_identification .tab-content').append '<div class="tab-pane" id="' + tabId + '"  data-basket_id="" data-transaction_id="' + selected_basket_tab.data('transaction_id') + '">' + $('#basket_template').html() + '</div>'
    
    selected_basket_tab = $(document).find($(document).find('#basket_list li:last-child a').attr('href'))
    $.each $(document).find('.is_selected_property'), ->
      if $(this).is(":checked")
        add_property_to_basket($(this).closest('.fields'))
    selected_basket_tab = $(document).find($(document).find('#basket_list li.active a').attr('href'))

  $(document).on 'click', '.remove_property_from_basket', ->
    $(this).closest('tr').remove()
    calculate_purchase_costs()

  $(document).on 'click', '.save_this_basket', ->
    console.log 'click Save this basket button'
    if selected_basket_tab.find('.basket_property_table tbody tr').length == 0
      sweetAlert '', 'Please select one property at lease', 'warning'
      return
    index = $('#basket_list').children().length
    if $(this).data('with_identify') == true
      with_identify = true
    else
      with_identify = false

    if selected_basket_tab.data('basket_id')
      ajax_url = '/transaction_baskets/' + selected_basket_tab.data('basket_id')
      ajax_type = 'PUT'
    else
      ajax_url = '/transaction_baskets/'
      ajax_type = 'POST'

    property_ids = []
    selected_basket_tab.find('.basket_property_table tbody tr').each ->
      property_ids.push($(this).data('property_id'))

    $.ajax
      url: ajax_url
      type: ajax_type
      dataType: 'json'
      data: { 
        basket_name: 'Basket ' + index, 
        transaction_id: selected_basket_tab.data('transaction_id'), 
        property_ids: property_ids, 
        with_identify: with_identify
      }
      success: (data) ->
        if data.status
          $('.left_col #sidebar-menu').replaceWith(data.content)

          $(document).find('#basket_list li.active').addClass('saved')
          selected_basket_tab.data('basket_id', data.basket.id)
          selected_basket_tab.find('.disable_editing_property').val("true")
          selected_basket_tab.find('.save_this_basket').hide()
          selected_basket_tab.find('.save_identify_this_basket_to_qi').show()
                                                                      .attr('disabled', false)

          $(document).find('.basket_property_table tbody tr td .input-mask-currency').attr('disabled', false)
          $('#basket_list li.active a i').addClass('red')
          $('.basket_property_table tbody tr td:first-child a').html('<span class="glyphicon glyphicon-ok"></span>')
          if with_identify == true
            set_attr_after_identify()
            successful_alert = "Saving and Identifying Basket " + index
          else  
            create_new_basket(index+1)
            successful_alert = "Saving Basket " + index + ", Creating Basket " + (index + 1)
          
          $.notify successful_alert, "success"
        else
          $.notify "Failed", "error"


  $(document).on 'click', '.save_identify_this_basket_to_qi', ->
    console.log 'click Save identify this basket to qi'
    $.ajax
      url: '/transaction_baskets/identify_basket_to_qi/' + selected_basket_tab.data('basket_id')
      type: 'POST'
      dataType: 'json'
      data: {transaction_id: selected_basket_tab.data('transaction_id')}
      success: (data) ->
        if data.status
          $('.left_col #sidebar-menu').replaceWith(data.content)
          set_attr_after_identify()
          sweetAlert '', success_identify_property_to_qi, 'info'
        else
          $.notify "Failed", "error"

  $(document).on 'change', '.property_identification_table .counter-cap-rate, .basket_property_table .counter-cap-rate', (e)->
    $(document).find('#' + $(this).closest("tr").attr("id") + '_asking_mode').val(0)
    $(this).closest('tr').find('.go_to_negotiations').text('Counter and Proceed')

  $(document).on 'change', '.property_identification_table .counter-price, .basket_property_table .counter-price', (e)->
    $(document).find('#' + $(this).closest("tr").attr("id") + '_asking_mode').val(0)
    $(this).closest('tr').find('.go_to_negotiations').text('Counter and Proceed')

  $(document).on 'keyup', ".property_identification_table .counter-cap-rate, .basket_property_table .counter-cap-rate", (e)->
    currentRent = $(this).closest('tr').find('td.current-rent').text().replace(/[^0-9\.]+/g,'')
    counterCapRate = $(this).val().replace(/\,/g, '')
    counterPrice = parseFloat(currentRent) * 100 / parseFloat(counterCapRate)
    $(this).closest('tr').find("td input.counter-price").val(counterPrice)
    
    # set value for form fields(not on buy mode)
    # $(document).find('#' + $(this).closest("tr").attr("id") + '_cap_rate').val(counterCapRate)
    # $(document).find('#' + $(this).closest("tr").attr("id") + '_price').val(counterPrice)

    $(document).find('#' + $(this).closest("tr").attr("id") + '_counter_cap_rate').val(counterCapRate)
    $(document).find('#' + $(this).closest("tr").attr("id") + '_counter_price').val(counterPrice)
    calculate_purchase_costs()

  $(document).on 'keyup', ".property_identification_table .counter-price, .basket_property_table .counter-price", (e)->
    currentRent = $(this).closest('tr').find('td.current-rent').text().replace(/[^0-9\.]+/g,'')
    counterPrice = $(this).val().replace(/\,/g, '')
    counterCapRate = parseFloat(currentRent) / parseFloat(counterPrice) * 100
    $(this).closest('tr').find("td input.counter-cap-rate").val(counterCapRate)
    
    # set value for form fields(not on buy mode)
    # $(document).find('#' + $(this).closest("tr").attr("id") + '_cap_rate').val(counterCapRate)
    # $(document).find('#' + $(this).closest("tr").attr("id") + '_price').val(counterPrice)

    $(document).find('#' + $(this).closest("tr").attr("id") + '_counter_cap_rate').val(counterCapRate)
    $(document).find('#' + $(this).closest("tr").attr("id") + '_counter_price').val(counterPrice)

    calculate_purchase_costs()

  $(document).on 'click', '.basket_property_table .go_to_negotiations', ->
    basket_id = selected_basket_tab.data('basket_id')
    cur_property_id = $(this).closest('tr').data('property_id')
    identification_rule = selected_basket_tab.find('#transaction_identification_rule').val()
    if identification_rule == 'three_property'
      selected_basket_tab.find('.basket_property_table tbody tr').each ->
        $(document).find('#' + $(this).attr("id") + '_in_three_property_basket').val(1)
    
    action_url = $(document).find('form.transaction-photo-gallery').attr('action') + '&basket_id=' + basket_id + '&cur_property=' + cur_property_id + '&identification_rule=' + identification_rule
    $(document).find('form.transaction-photo-gallery').attr('action', action_url)
    $(document).find('form.transaction-photo-gallery').submit()

  $(document).on 'ifChecked', '#contact_is_company_false', ->
    form_wrapper = $(this).closest('.form-wrapper')
    if form_wrapper.find('.form_submit_mode').val() == 'edit'
      if form_wrapper.find('.is_company').val() == 'true'
        swal {
          title: 'Are you sure?'
          text: 'Prior contact will be deleted'
          type: 'warning'
          showCancelButton: true
          cancelButtonText: "No"
          confirmButtonColor: '#DD6B55'
          confirmButtonText: 'Yes'
          closeOnConfirm: false
        }, (isConfirm)->
          if isConfirm
            form_wrapper.find('div.company-detail').hide()
            form_wrapper.find('label[for="contact_ein_or_ssn"]').text('EIN')
            form_wrapper.find('form input[type=text], form textarea').val('')
          else
            setTimeout (->
              form_wrapper.find('#contact_is_company_true').iCheck('check')
            ), 100  
          
          swal.close()
      else
        form_wrapper.find('div.company-detail').hide()
        form_wrapper.find('label[for="contact_ein_or_ssn"]').text('EIN')
  
  $(document).on 'ifChecked', '#contact_is_company_true', ->
    form_wrapper = $(this).closest('.form-wrapper')
    if form_wrapper.find('.form_submit_mode').val() == 'edit'
      if form_wrapper.find('.is_company').val() == 'false'
        swal {
          title: 'Are you sure?'
          text: 'Prior contact will be deleted'
          type: 'warning'
          showCancelButton: true
          cancelButtonText: "No"
          confirmButtonColor: '#DD6B55'
          confirmButtonText: 'Yes'
          closeOnConfirm: false
        }, (isConfirm)->
          if isConfirm
            form_wrapper.find('div.company-detail').show()
            form_wrapper.find('label[for="contact_ein_or_ssn"]').text('SSN')
            form_wrapper.find('form input[type=text], form textarea').val('')
          else
            setTimeout (->
              form_wrapper.find('#contact_is_company_false').iCheck('check')
            ), 100  
          
          swal.close()
      else
        form_wrapper.find('div.company-detail').show()
        form_wrapper.find('label[for="contact_ein_or_ssn"]').text('SSN')
  
  $(document).on 'ajax:success', '.new_contact, .edit_contact', (e, data, status, xhr) ->
    $.notify "Contact updated", "success"

  #--- end ---

  $(document).on 'ifChecked', '.radio_edit_mode_cap', ->
    $(this).parents(".transaction-property-calculation").find("input[name*='cap_rate']").prop('readonly', false)
    $(this).parents(".transaction-property-calculation").find("input[name*='sale_price']").prop('readonly', true)

    radioBox = $(this).parents(".transaction-property-calculation").find(".radio-box")
    capBox = $(this).parents(".transaction-property-calculation").find(".cap-rate-box")
    priceBox = $(this).parents(".transaction-property-calculation").find(".price-box")

    capBox.insertAfter(radioBox)
    capBox.find('label').text('Propose a Cap Rate')
    priceBox.find('label').text('This will result in an Asking Price of')

  $(document).on 'ifChecked', '.radio_edit_mode_price', ->
    $(this).parents(".transaction-property-calculation").find("input[name*='cap_rate']").prop('readonly', true)
    $(this).parents(".transaction-property-calculation").find("input[name*='sale_price']").prop('readonly', false)

    radioBox = $(this).parents(".transaction-property-calculation").find(".radio-box")
    capBox = $(this).parents(".transaction-property-calculation").find(".cap-rate-box")
    priceBox = $(this).parents(".transaction-property-calculation").find(".price-box")

    priceBox.insertAfter(radioBox)
    priceBox.find('label').text('Propose an Asking Price')
    capBox.find('label').text('This will result in a Cap Rate of')

  $(document).on 'keyup', ".transaction-property-calculation-readonly input[name^='updated_current_rent']", (e)->
    currentRent = $(this).val().replace(/\,/g, '')
    if $(this).parents('.fields').find('.radio_edit_mode_cap').is(':checked')
      currentCapRate = $(this).parents('.fields').find("input[name*='cap_rate']").val().replace(/\,/g, '')
      $(this).parents('.fields').find("input[name*='sale_price']").val(parseFloat(currentRent) * 100 / parseFloat(currentCapRate))  
    else
      currentPrice = $(this).parents('.fields').find("input[name*='sale_price']").val().replace(/\,/g, '')
      $(this).parents('.fields').find("input[name*='cap_rate']").val(parseFloat(currentRent) / parseFloat(currentPrice) * 100)
      
  $(document).on 'keyup', ".transaction-property-calculation input[name*='cap_rate']", (e)->
    currentRent = $(this).parents('.fields').find('.transaction-property-calculation-readonly .current-rent').val().replace(/\,/g, '')
    currentCapRate = $(this).val().replace(/\,/g, '')

    $(this).parents('.transaction-property-calculation').find("input[name*='sale_price']").val(parseFloat(currentRent) * 100 / parseFloat(currentCapRate))

  $(document).on 'keyup', ".transaction-property-calculation input[name*='sale_price']", (e)->
    currentRent = $(this).parents('.fields').find('.transaction-property-calculation-readonly .current-rent').val().replace(/\,/g, '')
    currentPrice = $(this).val().replace(/\,/g, '')

    $(this).parents('.transaction-property-calculation').find("input[name*='cap_rate']").val(parseFloat(currentRent) / parseFloat(currentPrice) * 100)

#  $(document).on 'change', '.transaction-property-select select.for-purchase', (e)->
#    currentRent = $(this).parents('.fields').find(".transaction-property-calculation-readonly .current-rent")
#    currentCap = $(this).parents('.fields').find(".transaction-property-calculation-readonly .current-cap-rate")
#    currentPrice = $(this).parents('.fields').find(".transaction-property-calculation-readonly .current-price")
#    currentImage = $(this).parents('.fields').find(".transaction-property-image img")

#    if $(this).val()
#      $.ajax
#        type: "POST"
#        url: "/xhr/get_property_data_for_transaction"
#        data: {id: $(this).val()}
#        dataType: "json"
#        success: (val) ->
#          currentRent.val(val.rent)
#          currentCap.val(val.cap)
#          currentPrice.val(val.price)
#          if val.image
#            currentImage.attr 'src', 'http://res.cloudinary.com/a1031fun-com/image/upload/c_scale/' + val.image
#            currentImage.attr 'alt', val.image
#          else
#            currentImage.attr 'src', "<%= asset_path('sale_house.jpg') %>"
#        error: (e) ->
#          console.log e
#    else
#      currentRent.val(0)
#      currentCap.val(0)
#      currentPrice.val(0)
#      currentImage.attr 'src', "<%= asset_path('sale_house.jpg') %>"
#      currentImage.attr 'alt', "Placeholder"

#  $(document).on 'change', '.transaction-property-select select.for-sale', (e)->
#    currentRent = $(this).parents('.fields').find(".transaction-property-calculation-readonly .current-rent")
#    currentImage = $(this).parents('.fields').find(".transaction-property-image img")

#    if $(this).val()
#      $.ajax
#        type: "POST"
#        url: "/xhr/get_property_data_for_transaction"
#        data: {id: $(this).val()}
#        dataType: "json"
#        success: (val) ->
#          currentRent.val(val.rent)
#          if val.image
#            currentImage.attr 'src', 'http://res.cloudinary.com/a1031fun-com/image/upload/c_scale/' + val.image
#            currentImage.attr 'alt', val.image
#          else
#            currentImage.attr 'src', "<%= asset_path('sale_house.jpg') %>"
#        error: (e) ->
#          console.log e
#    else
#      currentRent.val(0)
#      currentImage.attr 'src', "<%= asset_path('sale_house.jpg') %>"
#      currentImage.attr 'alt', "Placeholder"

  
  # Personnel Page
  $(document).on 'change', '#transaction_personnel_contact_id', ->
    if $(this).find('option:selected').text() == 'Add New'
      $('.transaction-personnel-contact-form-wrapper').show()
      $(document).find('div.personnel-individual-detail input').prop('disabled', false)
    else 
      $('.transaction-personnel-contact-form-wrapper').hide()
      $(document).find('div.personnel-business-detail input').prop('disabled', 'disabled')
      $(document).find('div.personnel-individual-detail input').prop('disabled', 'disabled')
  
  $(document).on 'ifChecked', '#transaction_personnel_contact_is_company_true', ->
    if this.checked
      $(document).find('div.personnel-business-detail').show()
      $(document).find('div.personnel-business-detail input').prop('disabled', false)
      $(document).find('div.personnel-individual-detail').hide()
      $(document).find('div.personnel-individual-detail input').prop('disabled', 'disabled')

  $(document).on 'ifChecked', '#transaction_personnel_contact_is_company_false', ->
    if this.checked
      $(document).find('div.personnel-business-detail').hide()
      $(document).find('div.personnel-business-detail input').prop('disabled', 'disabled')
      $(document).find('div.personnel-individual-detail').show()
      $(document).find('div.personnel-individual-detail input').prop('disabled', false)
  
  $(document).on 'ajax:success', '.edit_transaction_personnel, .new_transaction_personnel', (e, data, status, xhr) ->
    $.notify "Success!", "success"
    window.location.reload()
    # $(document).find(selected_transaction_sub_tab.find('.sale_buy_step_tab_sub li.active a').attr('href')).find('#transaction_personnel_contact_id').prop('disabled', 'disabled')
    # if selected_transaction_sub_tab.find('.sale_buy_step_tab_sub li.active').nextAll().length >= 1
    #   selected_transaction_sub_tab.find('.sale_buy_step_tab_sub li.active').next().find('a').click()
    # else if selected_transaction_sub_tab.nextAll().length >= 1
    #   selected_transaction_sub_tab.next().find('a').click()
    # else
    #   next_step = $(document).find('ul.wizard_steps li.selected').next()
    #   window.location.href = next_step.find('a').attr("href")
  
  $(document).on 'click', '.sale_buy_step_tab_sub li a', (e)->
    curPropertyId = $("#cur_property_id").val()
    selectedSubSubTabId = $(this).attr("id")
    
    if !isNaN(parseInt(curPropertyId)) && parseInt(curPropertyId) > 0
      $.ajax
        type: "POST"
        url: "/xhr/save_transaction_subtab"
        data: {id: curPropertyId, sub_subtab: selectedSubSubTabId}
        dataType: "json"
        success: (val) ->
          console.log val
        error: (e) ->
          console.log e