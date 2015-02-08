$.fn.notifyRemove = ->
  TIMING = 5000
  @delay(TIMING).fadeOut 'slow', => @remove()