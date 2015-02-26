$(document).on 'page:load ready', ->
  c = $ '#pims-index'

  if c.length
    c.on 'click', '.item-class .link-detail', ->
      $(@).closest('.item-class').find('.sub-classes').toggleClass('hide')
      false
