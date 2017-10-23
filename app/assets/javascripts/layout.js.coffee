$ ->
  $('.select2').select2()

  $(document).on 'click', '.add_nested_fields', ->
    setTimeout ->
      $('.select2').select2()
    , 10

