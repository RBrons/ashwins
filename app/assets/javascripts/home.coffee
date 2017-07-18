$ ->
  # show landing page modal
  if $(document).find('#is_show_landing_page').val() == 'true'
    $(document).find('#md-welcome').modal('show')
  
  $(document).find('#md-welcome .close').on 'click', ->
    # if user log in first time
    if $(this).data('back-path') == "/users/sign_in"
      return true
    else if $(this).data('back-path') != "/"
      window.location.href = $(this).data('back-url')
  