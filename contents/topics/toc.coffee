$ = jQuery

$(document).ready ->
  filterTopics(document.location.hash.substr(1))

  $('.topic-index a').attr('id', '')

  $('body').on 'click', '.topic-index a', (e)->
    e.preventDefault()
    filterTopics(e.target.href.split('#').pop())
    history.pushState(null, null, e.target.href)

$(window).on 'hashchange', (e)->
  e.preventDefault()
  filterTopics(document.location.hash.substr(1))

filterTopics = (fragment)->
  if fragment.length isnt 1
    $('.listing').show()
  else
    $('.listing[data-initial!='+fragment+']').hide()
    $('.listing[data-initial='+fragment+']').show()


