$ ->
  $(document).on 'click', '.project > .title', ->
    window.location.href = $(this).parent().find('.show-path').find('a').attr('href')

  $(document).on 'click', 'a.project-settings-icon', (e)->
    position = $(this).position()
    $(this).parent().parent().find('div.settings').css('left', (position.left - 100) + 'px')
    $(this).parent().parent().find('div.settings').toggle()

  $(document).on 'click', (e) ->
    if !$(e.target).hasClass('project-settings-icon')
      container = $("div.settings")
      if (!container.is(e.target) && (container.has(e.target).length == 0))
        container.hide();
