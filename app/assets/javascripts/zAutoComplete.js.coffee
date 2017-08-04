$ ->
# AutoComplete for Emails
  select_autoselect_option = (position, self) ->
    node             = $(self).parent().parent().find('.autocomplete')
    current_selected = node.find('li[class="selected"]')
    if current_selected.text().length == 0
      if position == 1
        node.find('li').removeClass('selected')
        node.find('li:first').addClass('selected')
        $(self).val node.find('li:first').text()
      else if position == -1
        node.find('li').removeClass('selected')
        node.find('li:last').addClass('selected')
        $(self).val node.find('li:last').text()
    else
      current_index = current_selected.index()
      console.log( 'Current Index : ' + current_index)
      if position == 1
        next = current_index + 1
        if node.find('li:eq('+next+')').text().length > 0
          node.find('li').removeClass('selected')
          node.find('li:eq('+next+')').addClass('selected')
          $(self).val node.find('li:eq('+next+')').text()
        else
          node.find('li').removeClass('selected')
          $(self).val($(self).parent().find('span.old-action-member-email').text())
      else if position == -1
        prev = current_index - 1
        if node.find('li:eq('+prev+')').text().length > 0 and prev != -1
          node.find('li').removeClass('selected')
          node.find('li:eq('+prev+')').addClass('selected')
          $(self).val node.find('li:eq('+prev+')').text()
        else
          node.find('li').removeClass('selected')
          $(self).val $(self).parent().find('span.old-action-member-email').text()
  fetch_data_with_xhr = (self) ->
    val = $(self).val()
    if val.length > 0
      $.ajax
        type: "GET"
        url: '/property/setting/emails?email='+val
        dataType: "JSON"
        success: (val) ->
          html = ''
          html = '<ul>'
          $.each val, (index, value)->
            html += '<li>'+value+'</li>'
          html += '</ul>'
          $(self).parent().parent().find('.autocomplete').html(html)
          $(self).parent().parent().find('.autocomplete').show()
        error: (e) ->
          console.log e

  $(document).on 'keypress', '.action-member-email', (e)->
    if e.keyCode == 13
       e.preventDefault()
       $(this).parent().parent().find('.autocomplete').hide()
       return false
    $(this).parent().find('span.old-action-member-email').text $(this).val()
    fetch_data_with_xhr(this)
  $(document).on 'click', (event)->
    if(!$(event.target).closest('.autocomplete').length)
      if($('.autocomplete').is(":visible"))
        $('.autocomplete').hide()
  $(document).on 'keyup', '.action-member-email', (e)->
    keyCode = e.keyCode or window.event
    switch keyCode
      when 38
        select_autoselect_option(-1, this)
      when 40
        select_autoselect_option(1, this)
    return

# AutoComplete for Client Name and Address
  select_autoselect_option_client = (position, self) ->
    node             = $(self).parent().find('.autocomplete')
    current_selected = node.find('.client-info[class="selected"]')
    if current_selected.text().length == 0
      if position == 1
        node.find('.client-info').removeClass('selected')
        node.find('.client-info:first').addClass('selected')
        $(self).val node.find('.client-info:first').text()
        $('input#transaction_client_id').val(node.find('.client-info:first').attr('data-id'))
      else if position == -1
        node.find('.client-info').removeClass('selected')
        node.find('.client-info:last').addClass('selected')
        $(self).val node.find('.client-info:last').text()
        $('input#transaction_client_id').val(node.find('.client-info:last').attr('data-id'))
    else
      current_index = current_selected.index()
      console.log( 'Current Index : ' + current_index)
      if position == 1
        next = current_index + 1
        if node.find('.client-info:eq('+next+')').text().length > 0
          node.find('.client-info').removeClass('selected')
          node.find('.client-info:eq('+next+')').addClass('selected')
          $(self).val node.find('.client-info:eq('+next+')').text()
          $('input#transaction_client_id').val(node.find('.client-info:eq('+next+')').attr('data-id'))
        else
          node.find('.client-info').removeClass('selected')
          $(self).val($(self).parent().find('span.old-transaction_client_id').text())
          $('input#transaction_client_id').val($(self).parent().find('span.old-transaction_client_id').attr('data-id'))
      else if position == -1
        prev = current_index - 1
        if node.find('.client-info:eq('+prev+')').text().length > 0 and prev != -1
          node.find('.client-info').removeClass('selected')
          node.find('.client-info:eq('+prev+')').addClass('selected')
          $(self).val node.find('.client-info:eq('+prev+')').text()
          $('input#transaction_client_id').val(node.find('.client-info:eq('+prev+')').attr('data-id'))
        else
          node.find('.client-info').removeClass('selected')
          $(self).val $(self).parent().find('span.old-transaction_client_id').text()
          $('input#transaction_client_id').val($(self).parent().find('span.old-transaction_client_id').attr('data-id'))
  fetch_data_with_xhr_client = (self) ->
    val = $(self).val()
    if val.length > 0
      $.ajax
        type: "GET"
        url: '/clients/address?val='+val
        dataType: "html"
        success: (val) ->
          $(self).parent().find('.autocomplete').html(val)
          $(self).parent().find('.autocomplete').show()
        error: (e) ->
          console.log e

  $(document).on 'keypress click', 'textarea#transaction_client_id', (e)->
    if e.keyCode == 13
      e.preventDefault()
      $(this).parent().find('.autocomplete').hide()
      return false
    $(this).parent().find('span.old-transaction_client_id').text($(this).val())
    fetch_data_with_xhr_client(this)
  $(document).on 'click', (event)->
    if(!$(event.target).closest('.autocomplete').length)
      if($('.autocomplete').is(":visible"))
        $('.autocomplete').hide()
  $(document).on 'keyup', 'textarea#transaction_client_id', (e)->
    keyCode = e.keyCode or window.event
    switch keyCode
      when 38
        select_autoselect_option_client(-1, this)
      when 40
        select_autoselect_option_client(1, this)
    return
  $(document).on 'click', 'div.client-info', (e)->
    $('input#transaction_client_id').val($(this).attr('data-id'))
    $('textarea#transaction_client_id').val($(this).text())
    $(this).parent().hide()

# AutoComplete for Client's Entity
  select_autoselect_option_client_entity = (position, self) ->
    node             = $(self).parent().find('.autocomplete')
    current_selected = node.find('.client-entity[class="selected"]')
    if current_selected.text().length == 0
      if position == 1
        node.find('.client-entity').removeClass('selected')
        node.find('.client-entity:first').addClass('selected')
        $(self).val node.find('.client-entity:first').text()
        $("input#client_entity_id").val node.find('.client-entity:first').attr("data-id")
      else if position == -1
        node.find('.client-entity').removeClass('selected')
        node.find('.client-entity:last').addClass('selected')
        $(self).val node.find('.client-entity:last').text()
        $("input#client_entity_id").val node.find('.client-entity:last').attr("data-id")
    else
      current_index = current_selected.index()
      if position == 1
        next = current_index + 1
        if node.find('.client-entity:eq('+next+')').text().length > 0
          node.find('.client-entity').removeClass('selected')
          node.find('.client-entity:eq('+next+')').addClass('selected')
          $(self).val node.find('.client-entity:eq('+next+')').text()
          $("input#client_entity_id").val node.find('.client-entity:eq('+next+')').attr("data-id")
        else
          node.find('.client-entity').removeClass('selected')
      else if position == -1
        prev = current_index - 1
        if node.find('.client-entity:eq('+prev+')').text().length > 0 and prev != -1
          node.find('.client-entity').removeClass('selected')
          node.find('.client-entity:eq('+prev+')').addClass('selected')
          $(self).val node.find('.client-entity:eq('+prev+')').text()
          $("input#client_entity_id").val node.find('.client-entity:eq('+prev+')').attr("data-id")
        else
          node.find('.client-entity').removeClass('selected')
  fetch_data_with_xhr_client_entity = (self) ->
    val = $(self).val()
    if val.length > 0
      $.ajax
        type: "GET"
        url: '/xhr/client_entity?val='+val
        dataType: "html"
        success: (val) ->
          $(self).parent().find('.autocomplete').html(val)
          $(self).parent().find('.autocomplete').show()
        error: (e) ->
          console.log e

  $(document).on "input click", 'input#client_entity', (e)->
    self = this
    if e.keyCode == 13
      e.preventDefault()
      $(self).parent().find('.autocomplete').hide()
      return false
    setTimeout(->
      fetch_data_with_xhr_client_entity(self)
    , 500)
  $(document).on 'click', (event)->
    if(!$(event.target).closest('.autocomplete').length)
      if($('.autocomplete').is(":visible"))
        $('.autocomplete').hide()
  $(document).on "keyup", "input#client_entity", (e)->
    keyCode = e.keyCode or window.event
    switch keyCode
      when 38
        select_autoselect_option_client_entity(-1, this)
      when 40
        select_autoselect_option_client_entity(1, this)
    return
  $(document).on 'click', "div.client-entity", (e)->
    $("input#client_entity_id").val($(this).attr('data-id'))
    $("input#client_entity").val($(this).text())
    $(this).closest('.autocomplete').hide()

# AutoComplete for StockHolder's Entity
  select_autoselect_option_client_entity = (position, self) ->
    node             = $(self).parent().find('.autocomplete')
    current_selected = node.find('.client-entity[class="selected"]')
    if current_selected.text().length == 0
      if position == 1
        node.find('.client-entity').removeClass('selected')
        node.find('.client-entity:first').addClass('selected')
        $(self).val node.find('.client-entity:first').text()
        $("input#client_entity_id").val node.find('.client-entity:first').attr("data-id")
      else if position == -1
        node.find('.client-entity').removeClass('selected')
        node.find('.client-entity:last').addClass('selected')
        $(self).val node.find('.client-entity:last').text()
        $("input#client_entity_id").val node.find('.client-entity:last').attr("data-id")
    else
      current_index = current_selected.index()
      if position == 1
        next = current_index + 1
        if node.find('.client-entity:eq('+next+')').text().length > 0
          node.find('.client-entity').removeClass('selected')
          node.find('.client-entity:eq('+next+')').addClass('selected')
          $(self).val node.find('.client-entity:eq('+next+')').text()
          $("input#client_entity_id").val node.find('.client-entity:eq('+next+')').attr("data-id")
        else
          node.find('.client-entity').removeClass('selected')
      else if position == -1
        prev = current_index - 1
        if node.find('.client-entity:eq('+prev+')').text().length > 0 and prev != -1
          node.find('.client-entity').removeClass('selected')
          node.find('.client-entity:eq('+prev+')').addClass('selected')
          $(self).val node.find('.client-entity:eq('+prev+')').text()
          $("input#client_entity_id").val node.find('.client-entity:eq('+prev+')').attr("data-id")
        else
          node.find('.client-entity').removeClass('selected')
  fetch_data_with_xhr_client_entity = (self) ->
    val = $(self).val()
    if val.length > 0
      $.ajax
        type: "GET"
        url: '/xhr/client_entity?val='+val+'&stockholder=true'
        dataType: "html"
        success: (val) ->
          $(self).parent().find('.autocomplete').html(val)
          $(self).parent().find('.autocomplete').show()
        error: (e) ->
          console.log e

  $(document).on "input click", 'input#stock_holder_entity, input#member_entity', (e)->
    self = this
    if e.keyCode == 13
      e.preventDefault()
      $(self).parent().find('.autocomplete').hide()
      return false
    setTimeout(->
      fetch_data_with_xhr_client_entity(self)
    , 500)
  $(document).on 'click', (event)->
    if(!$(event.target).closest('.autocomplete').length)
      if($('.autocomplete').is(":visible"))
        $('.autocomplete').hide()
  $(document).on "keyup", "input#stock_holder_entity, input#member_entity", (e)->
    keyCode = e.keyCode or window.event
    switch keyCode
      when 38
        select_autoselect_option_client_entity(-1, this)
      when 40
        select_autoselect_option_client_entity(1, this)
    return
  $(document).on 'click', "div.client-entity", (e)->
    $("input#stock_holder_entity_id").val($(this).attr('data-id'))
    $("input#stock_holder_entity").val($(this).text())
    $(this).closest('.autocomplete').hide()