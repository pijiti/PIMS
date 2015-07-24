$(document).on 'page:load ready', ->
  c = $ '#pims-index'

  if c.length
    c.on 'click', '.store .link-roles', ->
      $(@).closest('.store').find('.roles').toggleClass('hide')