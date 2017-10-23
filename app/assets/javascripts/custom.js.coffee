$ ->

  $(document).on 'change', 'select#permission_type', ->
    email = $(this).attr('user-email')
    if email
      permission_type = $(this, "option:selected").val();
      resource_key    = $(this).attr('resource_key');
      $.ajax
        type: "POST"
        url: '/property/setting'
        data: {email: email, permission_type: permission_type, id: resource_key}
        dataType: "text"
        success: (val) ->
        error: (e) ->
          console.log e
  $(document).on 'click', 'textarea#comment', ->
    $(this).css('height', '150px')
  $(document).click (e) ->
    if !$(e.target).is('#comment') and !$(e.target).is('input[name="files[]"]') and !$(e.target).is('input[type="submit"]')
      container = $(document).find('textarea#comment')
      if (!container.is(e.target) && (container.has(e.target).length == 0))
        container.css('height', '50px')
