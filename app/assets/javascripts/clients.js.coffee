$ ->
  $(document).on 'click', "#client_is_person_false", ->
    if this.checked
      $(".contact").html('Contact');
      $("input#client_entity").parent().parent().show();
      sort_select_options($(document).find("select#client_state")[0], false)

  $(document).on 'click', "#client_is_person_true", ->
    if this.checked
      $(".contact").html('&nbsp;');
      $("input#client_entity").parent().parent().hide();
      sort_select_options($(document).find("select#client_state")[0], true)

  $(document).on "click", "a.client-form-new-entity", ->
    val = $(document).find("input#client_entity").val()
    url = '/entities/new?val='+val
    $(this).closest('.autocomplete').hide()
    $.ajax
      type: "get"
      url: url
      dataType: "html"
      success: (val) ->
        $("div#ClientFormNewEntity").find(".model-body").html(val)
      error: (e) ->
        console.log e
    $("div#ClientFormNewEntity").modal()

  $("a.client-form-entity-pick-form-list").on 'click', ->
    url = "/entities/xhr_list"
    $.ajax
      type: "get"
      url: url
      dataType: "html"
      success: (val) ->
        $("div#ClientFormEntityPickFormList").find('.model-body').html(val)
      error: (e) ->
        console.log e
    $("div#ClientFormEntityPickFormList").modal()

  $(document).on 'click', 'div.entity-object-action', ->
    $("input#client_entity_id").val($(this).parent().attr("data-id"))
    $("input#client_entity").val($(this).parent().find(".object-text").text())
    try
      json = JSON.parse $(this).parent().find(".object-json").text()
      $(document).find("input#client_first_name").val(json.first_name)
      $(document).find("input#client_last_name").val(json.last_name)
      $(document).find("input#client_phone1").val(json.phone1)
      $(document).find("input#client_phone2").val(json.phone2)
      $(document).find("input#client_fax").val(json.fax)
      $(document).find("input#client_email").val(json.email)
      $(document).find("input#client_postal_address").val(json.postal_address)
      $(document).find("input#client_city").val(json.city)
      $(document).find("input#client_state").find('option:selected').removeAttr("selected");
      $(document).find("input#client_state, option[value='"+json.state+"']").attr("selected", "selected")
      $(document).find("input#client_zip").val(json.zip)
    catch

    $("div.ind-entity-popup").removeClass('selected')
    $(this).parent().addClass('selected')
    setTimeout(->
      $(document).find("div#ClientFormEntityPickFormList").modal("hide")
    , 500)    

  $(document).on 'ajax:beforeSend', 'form#new_entity', ->
    $.blockUI()

  $(document).on 'ajax:success', 'form#new_entity', (data, xhr, status)->
    url = "/entities/"+xhr
    $.ajax
      type: "get"
      url: url
      dataType: "json"
      success: (val) ->
        $("input#client_entity_id").val(val.id)
        $("input#client_entity").val(val.name)
        $("div#ClientFormNewEntity").modal("hide")
        $.unblockUI()
      error: (e) ->
        console.log e

  $(document).on 'ajax:error', 'form#new_entity', (data, xhr, status)->
    $("div#ClientFormNewEntity").find('.model-body').html(xhr.responseText)
    $.unblockUI()

  $("#entity-groups-tree").jstree  
    'core':
      'animation': 0
      'check_callback': true
      'themes': 'stripes': true
      'data':
        'url': (node) ->
          '/xhr/entity_groups.json'
        'data': (node) ->
          { 'id': node.id }
    'types':
      '#':
        'max_children': 1
        'max_depth': 4
        'valid_children': [ 'root' ]
      'root':
        'icon': '/static/3.3.4/assets/images/tree_icon.png'
        'valid_children': [ 'default' ]
      'default': 'valid_children': [
        'default'
        'file'
      ]
      'file':
        'icon': 'glyphicon glyphicon-file'
        'valid_children': []
    'plugins': [
      'contextmenu'
      'dnd'
      'search'
      'state'
      'types'
    ]
    'contextmenu' :
      'items': (node) ->
        tmp = $.jstree.defaults.contextmenu.items()
        delete tmp.ccp
        tmp.rename.action = (data) ->
          inst = $.jstree.reference(data.reference)
          obj = inst.get_node(data.reference)          
          text_ = obj.text
          text_ = text_.substr(0, text_.indexOf('<')-1)
          inst.set_text(obj, text_)          
          inst.edit obj
        tmp

  $('#entity-groups-tree').on('select_node.jstree', (e, data) ->
    r = []
    p = []
    i = 0
    j = data.selected.length
    while i < j
      r.push data.instance.get_node(data.selected[i]).text
      p.push data.instance.get_node(data.selected[i]).id
      i++
    #$('#event_result').html 'Selected: ' + r.join(', ')
    #alert(r.join(', '))
    #alert(p)
    #alert($('#current_group_id').val())
    if p[0] == ($('#current_group_id').val())
      #alert('yay')
    else
      url = "/clients/index?grp=" + p[0]
      #if p[0] == '0'
        #url = "/clients/index"      
      $.ajax
        type: "get"
        url: url
        dataType: "html"
        success: (val) ->
          $("div#entities-list").html(val)
          $('#current_group_id').val(p[0])
          manage_jsGrid_UI()
        error: (e) ->
          console.log e
    return
  )

  tree_nodes = []

  $('#entity-groups-tree').on('model.jstree', (e, data) ->
    #alert('tree changes')
    #alert(data.parent)
    #alert(data.nodes)
    if tree_nodes.length == 0
      tree_nodes = data.nodes    
    return
  )

  $('#entity-groups-tree').on('rename_node.jstree', (e, data) ->
    #alert('node renamed')
    #alert(data.old)
    #alert(data.text)
    #alert(data.node.id)
    #alert('parent ' + data.node.parent)
    #alert(tree_nodes)
    if tree_nodes.indexOf(data.node.id) == -1
      #alert('new node')
      #inst = $.jstree.reference(data.reference)
      #parent = inst.get_parent(data.node)
      #parent1 = $.jstree.reference('#entity-groups-tree').get_parent(data.node)
      #alert('parent id is : ' + parent1)
      $.ajax
        url: '/groups'
        type: 'post'
        dataType: 'json'
        data: {"group": {"name": data.text, "gtype": "Entity", "parent_id": data.node.parent}}
        success: (sdata) ->
          #alert(sdata.id)
          #alert(sdata.name)
          $.jstree.reference('#entity-groups-tree').set_id(data.node, sdata.id)
          $.jstree.reference('#entity-groups-tree').set_text(data.node, sdata.name + 
            '<a href="#" class="addtogroup" id="grp_' + sdata.id + '"><img  src="/assets/plusCyan.png" id="igrp_' +
            sdata.id + '"></img></a>')
    else
      #alert('edit node')
      $.ajax
        url: '/groups/' + data.node.id
        type: 'patch'
        dataType: 'json'
        data: {"group": {"name": data.text, "gtype": "Entity", "parent_id": data.node.parent}}
        success: (sdata) ->
          #alert(sdata.id)
          #alert(sdata.name)
          $.jstree.reference('#entity-groups-tree').set_id(data.node, sdata.id)
          $.jstree.reference('#entity-groups-tree').set_text(data.node, sdata.name + 
            '<a href="#" class="addtogroup" id="grp_' + sdata.id + '"><img  src="/assets/plusCyan.png" id="igrp_' +
            sdata.id + '"></img></a>')
    return
  )

  $('#entity-groups-tree').on('delete_node.jstree', (e, data) ->
    #alert(data.node.id)
    $.ajax
      url: '/groups/' + data.node.id
      type: 'delete'
      dataType: 'json'
      success: (sdata) ->
        #
        $('#entity-groups-tree').jstree(true).refresh();
    return
  )

  $(document).on 'click', "#add_button" , (e) ->
    #prevent Default functionality
    #alert 'add ...'
    e.preventDefault()
    actionurl = '/clients/index'
    $.ajax
      url: actionurl
      type: 'post'
      dataType: 'html'
      data: $('#addform').serialize()
      success: (data) ->
        $("div#entities-list").html(data)
        manage_jsGrid_UI()  

  $(document).on 'click', "#remove_button" , (e) ->
    #prevent Default functionality
    e.preventDefault()
    actionurl = '/clients/index'
    $.ajax
      url: actionurl
      type: 'post'
      dataType: 'html'
      data: $('#removeform').serialize()
      success: (data) ->
        $("div#entities-list").html(data)
        manage_jsGrid_UI()  

 
  $(document).on 'click', "#multi_add_entities" , (e) ->
    #prevent Default functionality
    #alert 'add multi...'
    e.preventDefault()
    ents = $(document).find('input#multi_delete_objects').val()
    #alert ents
    actionurl = '/clients/index'
    if ents.length > 0
      $(document).find('input#multi_add_entities').val(ents)
      selgrp = $(document).find('select#group_id').val()
      #alert selgrp
      $.ajax
        url: actionurl
        type: 'post'
        dataType: 'html'
        data: $('#addmultiform').serialize()
        success: (data) ->
          $('#entity-groups-tree').jstree('deselect_all')
          $('#entity-groups-tree').jstree('select_node', selgrp)
          $("div#entities-list").html(data)
          manage_jsGrid_UI()  

  $(document).on 'click', "#multi_remove_entities" , (e) ->
    #prevent Default functionality
    #alert 'remove multi...'
    e.preventDefault()
    ents = $(document).find('input#multi_delete_objects').val()
    #alert ents
    actionurl = '/clients/index'
    if ents.length > 0
      $(document).find('input#multi_remove_entities').val(ents)
      $.ajax
        url: actionurl
        type: 'post'
        dataType: 'html'
        data: $('#removemultiform').serialize()
        success: (data) ->
          $("div#entities-list").html(data)
          manage_jsGrid_UI()  

             
  $(document).on 'click', "a.addtogroup" , (e) ->
    e.preventDefault()
    ents = $(document).find('input#multi_delete_objects').val()
    #prevent Default functionality      
    ids = e.target.id.split('_')
    #ents = $(document).find('input#multi_delete_objects').val()
    #alert ents
    actionurl = '/clients/index'
    if ents.length > 0
      $(document).find('input#multi_add_entities').val(ents)
      selgrp = ids[1]
      #alert selgrp
      $.ajax
        url: actionurl
        type: 'post'
        dataType: 'html'
        data: {'group_id': selgrp, 'form_type': 'addmultitogroup', 'multi_add_entities': ents}
        success: (data) ->
          $('#entity-groups-tree').jstree('deselect_all')
          $('#entity-groups-tree').jstree('select_node', selgrp)
          $("div#entities-list").html(data)
          manage_jsGrid_UI()  
  
