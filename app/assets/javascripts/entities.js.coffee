$ ->
  $(document).ready ->
    $('.dropdown-toggle').dropdown()

  $(document).on 'change', 'select#entity_type_', ->
    val = $('option:selected', this).text()
    $.ajax
      type: "POST"
      url: '/entities/share_or_interest'
      data: {val: val}
      dataType: "text"
      success: (val) ->
        $(document).find('#entity_number_of_share').attr('name', val)
      error: (e) ->
        console.log e

  $(document).on 'keyup', 'input#entity_name', ->
    $(document).find('button#save_btn').addClass('new_style_save')
    $(document).find('button#save_btn').removeClass('default_style_save')
    if $(document).find('input#entity_name').val() == ''

      $(document).find('button#save_btn').removeClass('new_style_save')
      $(document).find('button#save_btn').addClass('default_style_save')

  $(document).on "click", "a.entity-new", ->
    $.ajax
      type: "POST"
      url: "/xhr/entity_type_list"
      dataType: "html"
      success: (val) ->
        $(document).find("#EntityTypeList").html(val)
        $(document).find("#EntityTypeList").show()
      error: (e) ->
        console.log e
  $(document).on 'click', (e) ->
    container = $("div#EntityTypeList")
    if (!container.is(e.target) && (container.has(e.target).length == 0))
      container.hide()
  $(document).on "click", ".type", ->
    val = $(this).text()
    window.location = "/entities/new?type="+val

  $(document).on 'ajax:beforeSend', 'a.resource-index-corporation', ->
    $("a.resource-index-corporation").removeClass("active")
    $(this).addClass("active")
    $.blockUI()

  $(document).on 'ajax:success', 'a.resource-index-corporation', (data, xhr, status)->
    $(document).find('.resource-list').html(xhr)
    # Manage Styling of Table Grid
    $(document).find('table#data_table').DataTable
      "paging": false
      "searching": false
      "ordering":  false
      "lengthChange": false
      "paginate": false
      "info": false

    $(document).find('#data_table_length').hide()
    $(document).find('table#data_table2').DataTable
      "paging": false
      "searching": false
      "ordering":  false
      "lengthChange": false
      "paginate": false
      "info": false

    $(document).find('#data_table2_info').hide()
    # Manage Styling of Table Grid
    $.unblockUI()

  # $(document).on 'keypress', '#target', ->
   #$(document).find('button#save_btn').css('background', '#cee9c8')

