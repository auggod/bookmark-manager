/*
prevent_bust = 0

window.onbeforeunload = ->
  prevent_bust++

setInterval (->
  if prevent_bust > 0
    prevent_bust -= 2
    window.top.location = 'http://null.localhost/'
), 1
*/
