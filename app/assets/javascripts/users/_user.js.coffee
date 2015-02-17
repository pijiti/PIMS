$(document).on 'page:load ready', ->
  c = $ '#pims-index'

  if c.length
    c.on 'click', '.user .link-roles', ->
      $(@).closest('.user').find('.roles').toggleClass('hide')
      false
