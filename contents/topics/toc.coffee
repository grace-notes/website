$ = jQuery

$(document).ready ->
  $('body').on 'click', '.topic-index a', (e)->
    e.preventDefault()
    link = e.target
    if $(link).attr('href') is "#all"
      $('.listing').show()
    else
      $('.listing').hide()
      $('.listing[data-initial='+$(link).attr('href').substr(1)+']').show()
