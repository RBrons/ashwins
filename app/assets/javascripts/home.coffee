$ ->
  # show landing page modal
  if $(document).find('#is_show_landing_page').val() == 'true'
    $(document).find('#md-welcome').modal('show')
  
  $(document).find('#md-welcome .close').on 'click', ->
    if $(this).data('back-path') != "/"
      window.location.href = $(this).data('back-url')
  