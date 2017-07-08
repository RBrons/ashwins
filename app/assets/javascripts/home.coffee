$ ->
  # show landing page modal
  if $(document).find('#is_show_landing_page').val() == 'true'
    $(document).find('#md-welcome').modal('show')
  