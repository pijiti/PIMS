$(document).on 'page:load ready', ->
  c = $ '#pims-index'

  if c.length
    c.on 'click', '.pharm-item .link-sub', ->
      $(@).closest('.pharm-item').find('.sub-classes').toggleClass('hide')
      false

  if c.length
    c.on 'click', '.pharm-item .link-brand', ->
      $(@).closest('.pharm-item').find('.brands').toggleClass('hide')
      false

