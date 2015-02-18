$(document).on 'page:load ready', ->
  c = $ '#pims-index'

  if c.length
    c.on 'click', '.vendor .link-detail', ->
      $(@).closest('.vendor').find('.details').toggleClass('hide')
      false
