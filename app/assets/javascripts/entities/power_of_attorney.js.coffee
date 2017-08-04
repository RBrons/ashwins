$ ->
  $(document).on "ajax:success", "a.entity-page-xhr, form.entity-page-xhr", (data, xhr, status)->
    str = "#entity_"
    pfname = $(str + "first_name").val()
    if !pfname
        str = "#power_of_attorney_"
        pfname = $(str + "first_name").val()
    plname = $(str + "last_name").val()
    afname = $(str + "first_name2").val()
    alname = $(str + "last_name2").val()
    if pfname 
      $('#edit-title-poa').html(afname + " " + alname + " POA for " + pfname + " " + plname)
    if (typeof xhr) == "object" && xhr.redirect != undefined
      window.location.href = xhr.redirect+"?just_created="+xhr.just_created      
    else
      tab_ = $("#int_action").val()
      if tab_
        str_ = " / "        
        $("#int-action-poa").html(str_ + '<a href="#">'+tab_+'</a>')
      $.scrollTo(0)
      $.unblockUI()
