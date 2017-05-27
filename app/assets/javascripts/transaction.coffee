
$ ->
  # Global Variables
  selected_offer_tab = $(document).find($(document).find('#offer_list li.active a').attr('href'))
  last_counteroffer = ""

  # Sale
  $(document).on 'ifChecked', '#transaction_seller_person_is_true', ->
    $(document).find('div.sale-tr-pr-detail').show()
    $(document).find('div.sale-tr-et-detail').hide()

  $(document).on 'ifChecked', '#transaction_seller_person_is_false', ->
    if this.checked
      $(document).find('div.sale-tr-pr-detail').hide();
      $(document).find('div.sale-tr-et-detail').show();

  $(document).on 'click', '#save-and-next', ->


  # Purchase
  $(document).on 'ifChecked', '#transaction_purchaser_person_is_true', ->
    if this.checked
      $(document).find('div.purchase-tr-pr-detail').show();
      $(document).find('div.purchase-tr-et-detail').hide();

  $(document).on 'ifChecked', '#transaction_purchaser_person_is_false', ->
    if this.checked
      $(document).find('div.purchase-tr-pr-detail').hide();
      $(document).find('div.purchase-tr-et-detail').show();


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

# Negotiations Step in Sale Wizard
  # - Offer and Acceptance
  $(document).on 'click', '.nav-tabs #new_offer', (e)->
    e.preventDefault()
    index = $('#offer_list').children().length
    elem = $(this)

    $.ajax
      url: '/transaction_property_offers/'
      type: 'POST'
      dataType: 'json'
      data: { offer_name: 'Offeror ' + index, transaction_property_id: $(this).data('tran-prop-id'), is_accepted: false }
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


  # - Taks list on LOI
  $(document).on 'ifChanged', '#letter_of_intent_section .to_do .field_list .task_status', (e)->
    if this.checked
      $(this).parent().parent().parent().addClass('done')
    else
      $(this).parent().parent().parent().removeClass('done')

  # - Taks list on PSA
  $(document).on 'ifChanged', '#purchase_sale_agreement_section .to_do .field_list .task_status', (e)->
    if this.checked
      # $.ajax
      #   url: ''
      #   type: 'POST'
      #   dataType: 'json'
      #   success: (data) ->
      #     if data
      #       $(document).find('.side-menu>li>.nav.child_menu>li.current-page').addClass('in-contract')
      #     else
      $(this).parent().parent().parent().addClass('done')
    else
      # $.ajax
      #   url: ''
      #   type: 'POST'
      #   dataType: 'json'
      #   success: (data) ->
      #     if data
      #       $(document).find('.side-menu>li>.nav.child_menu>li.current-page').removeClass('in-contract')
      #     else
      $(this).parent().parent().parent().removeClass('done')

    if $('#purchase_sale_agreement_section .to_do .field_list .task_status').filter(':checked').length == $('#purchase_sale_agreement_section .to_do .field_list .task_status').length
      $(document).find('.side-menu>li>.nav.child_menu>li.current-page').addClass('in-contract')
    else
      $(document).find('.side-menu>li>.nav.child_menu>li.current-page').removeClass('in-contract')

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
      container.hide();

  $(document).on 'nested:fieldAdded', (event) ->
    field = event.field
    $(document).find(field.find('.input-mask-currency')).inputmask
      alias: 'currency',
      rightAlign: false,
      prefix: ''

  # Offer and Acceptance

  $("#offer_list li").children('a').first().click()
  selected_offer_tab = $(document).find($("#offer_list li").children('a').first().attr('href'))

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
            selected_offer_tab.find('.btn_accept_counteroffer').text('Counter Accepted')
          else
            selected_offer_tab.find('.add_counteroffer').text('Client Counter')
            selected_offer_tab.find('.btn_accept_counteroffer').text('Accept Counter')

          selected_offer_tab.find('.counteroffer_action_buttons_wrapper').show()
          selected_offer_tab.find('.add_counteroffer').attr("disabled", false)
          selected_offer_tab.find('.last_counteroffer_price').val('$' + parseFloat(response.counteroffer.offered_price).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))


  initialize_editable_date_field()

  initialize_editable_currency_field = ->
    $(document).find('.editable-currency').editable
      type: 'text',
      tpl: '<input class="offered-price" type="text">',
      params: (params) ->
        params.value = $(document).find('input.offered-price').inputmask('unmaskedvalue');
        return params
      emptytext: 'Enter Amount of Offer'
      success: (response) ->
        if response.counteroffer.offered_date && response.counteroffer.offered_price
          if last_counteroffer  == "Client"
            selected_offer_tab.find('.add_counteroffer').text('Buyer Counter')
            selected_offer_tab.find('.btn_accept_counteroffer').text('Counter Accepted')
          else
            selected_offer_tab.find('.add_counteroffer').text('Client Counter')
            selected_offer_tab.find('.btn_accept_counteroffer').text('Accept Counter')

          selected_offer_tab.find('.counteroffer_action_buttons_wrapper').show()
          selected_offer_tab.find('.add_counteroffer').attr("disabled", false)
          selected_offer_tab.find('.last_counteroffer_price').val('$' + parseFloat(response.counteroffer.offered_price).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))


  initialize_editable_currency_field()

  $(document).on "focus", "input.offered-price", ->
    $(this).inputmask
      alias: 'currency'
      rightAlign: false
      prefix: '$ '
      removeMaskOnSubmit: true
      positionCaretOnTab: true

  $(document).on 'click', '#offer_list li a', (e)->
    selected_offer_tab = $(document).find($(this).attr('href'))

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
          $.notify "Success!", "success"
        else
          $.notify "Failed!", "error"

  add_counteroffer_row = (offer_id, date, offeror, price) ->
    date = date || moment().format('YYYY-MM-DD')
    if price != ""
      unformated_price = Number(price.replace(/[^0-9\.]+/g,""));
    else
       unformated_price = ""

    $.ajax
      url: '/counteroffers/'
      type: 'POST'
      dataType: 'json'
      data: { transaction_property_offer_id: offer_id, offer_type: offeror, offered_date: date, offered_price: unformated_price }
      success: (data) ->
        if data.status
          add_row_html = '<tr data-counteroffer-id="' + data.counteroffer_id + '">
                            <td width="150">
                                <span class="editable-date" data-name="offered_date" data-url="/counteroffers/' + data.counteroffer_id + '" data-type="combodate" data-value="' + date + '" data-format="YYYY-MM-DD" data-viewformat="MM/DD/YYYY"></span>
                            </td>
                            <td width="300">
                                <span>' + offeror + '</span>
                            </td>
                            <td>
                                <span class="green editable-currency" data-name="offered_price" data-type="text" data-url="/counteroffers/' + data.counteroffer_id + '" data-value="' + price + '"></span>
                            </td>
                            <td>
                                <a href="#" class="delete_counteroffer btn btn-danger btn-xs"><i class="fa fa-trash-o"></i></a>
                            </td>
                        </tr>'

          selected_offer_tab.find('.counteroffer_history tr.last_row').before(add_row_html)
          initialize_editable_currency_field()
          initialize_editable_date_field()
          selected_offer_tab.find('.add_counteroffer').prop("disabled", "disabled")
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
    $.ajax
      url: '/counteroffers/' + table_tr.data('counteroffer-id')
      type: 'DELETE'
      dataType: 'json'
      success: (data) ->
        if data
          selected_offer_tab.find('.last_counteroffer_price').val(table_tr.prev().children().find('span.editable-currency').text())
          table_tr.remove()
          if selected_offer_tab.find('.counteroffer_history tr').length == 1
            selected_offer_tab.find('.initial_log_counteroffer').show()
            selected_offer_tab.find('.ask_accepted').show()
            selected_offer_tab.find('.counteroffer_action_buttons_wrapper').hide()

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

          selected_offer_tab.find('.btn_accept_counteroffer').attr('disabled', 'disabled')
          selected_offer_tab.find('.add_counteroffer').attr('disabled', 'disabled')
                                                      .hide()
          selected_offer_tab.find('.initial_log_counteroffer').attr('disabled', 'disabled')
                                                              .hide()
          selected_offer_tab.find('.ask_accepted').attr('disabled', 'disabled')
                                                  .hide()
          $(document).find('#relinquishing_purchaser_name').val(data.offer_name)
                                                           .show()
          $(document).find('#relinquishing_property_sale_price').val(selected_offer_tab.find('.last_counteroffer_price').val())

          loi_description = data.offer_name + ' is purchasing ' + $(document).find('#negotiated_property').val() + ' for ' + selected_offer_tab.find('.last_counteroffer_price').val()
          $(document).find('#loi_description').text(loi_description)
          $(document).find('#loi_description').show()

          $('#negotions_tab a#letter_of_intent').click()
        else
          $.notify "Failed", "error"

  $(document).on 'click', '#back_prev_tab', (e) ->
    e.preventDefault()
    $('#negotions_tab li.active').prev().find('a').click()

# End of Alex's code

  # Show modal for submenu of top menu
  $(document).on 'click', '.top-header ul li a > span', (e)->
    e.preventDefault()
    if($(this).attr('id') == 'add-client')
      $.ajax
        type: "POST"
        url: "/xhr/entity_type_list"
        dataType: "html"
        success: (val) ->
          $(document).find("#md-add-client .modal-body").html(val);
        error: (e) ->
          console.log e

    modal_id = '#md-' + $(this).attr('id')
    $(modal_id).modal()

  # Prevent edit transaction form submit on enter
  $(document).on 'keyup keypress', 'form#edit_transaction', (e)->
    keyCode = e.keyCode || e.which
    if keyCode == 13
      e.preventDefault()
      return false

  $(document).on 'ifChecked', '.radio_edit_mode_cap', ->
    $(this).parents(".transaction-property-calculation").find("input[name*='cap_rate']").prop('readonly', false)
    $(this).parents(".transaction-property-calculation").find("input[name*='sale_price']").prop('readonly', true)

  $(document).on 'ifChecked', '.radio_edit_mode_price', ->
    $(this).parents(".transaction-property-calculation").find("input[name*='cap_rate']").prop('readonly', true)
    $(this).parents(".transaction-property-calculation").find("input[name*='sale_price']").prop('readonly', false)

  $(document).on 'keyup', ".transaction-property-calculation input[name*='cap_rate']", (e)->
    currentRent = $(this).parents('.fields').find('.transaction-property-calculation-readonly .current-rent').val().replace(/\,/g, '')
    currentCapRate = $(this).val().replace(/\,/g, '')

    $(this).parents('.transaction-property-calculation').find("input[name*='sale_price']").val(parseFloat(currentRent) * parseFloat(currentCapRate))

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