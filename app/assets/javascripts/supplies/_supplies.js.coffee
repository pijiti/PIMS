$(document).on 'page:load ready', ->
  c = $ '#pims-index'

  if c.length
    c.on 'click', '.supply .link-batches', ->
      $(@).closest('.supply').find('.batches').toggleClass('hide')
      false

