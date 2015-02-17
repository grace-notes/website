
$(document).ready (e)->
  $('#TOC a').attr 'href', ->
    $(this).attr('href').replace(/^.*#/, '#')
  
  $('body').scrollspy({
    target: '#TOC'
  }).scrollspy('refresh')

  toc = $('#TOC')
  $('body').on 'activate.bs.scrollspy', (e)->
    height = toc.outerHeight()
    top = toc.find('.active').position().top
    if toc.find('.active .active').length
      top =  top + toc.find('.active .active').position().top
    targetScroll = toc.scrollTop() + top - height/2

    $('#TOC').stop().animate({
      scrollTop: targetScroll
    }, 400)
