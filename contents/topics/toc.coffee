$ = jQuery

$(document).ready ->
  $('.topic-index a').click (e)->
    e.preventDefault()
    if $(this).attr('href') is "#all"
      $('.listing').show()
    else
      $('.listing').hide()
      $('.listing[data-initial='+$(this).attr('href').substr(1)+']').show()
