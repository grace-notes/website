
$(document).ready (e)->
  $('#TOC a').attr 'href', ->
    $(this).attr('href').replace(/^.*#/, '#')
  
  $('body').scrollspy({
    target: '#TOC'
  }).scrollspy('refresh')

  toc = $('#TOC')
  $('body').on 'activate.bs.scrollspy', (e)->
    height = toc.outerHeight()
    position = toc.find('.active').position()
    targetScroll = toc.scrollTop() + position.top - height/2

    $('#TOC').stop().animate({
      scrollTop: targetScroll
    }, 400)
