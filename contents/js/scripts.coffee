$ = jQuery

$(document).ready ->

  $('p,li,em,i,strong,b,u,span').hyphenate('en-us')

  # Track pdf links
  
  $("body").on 'click', 'a[href*=".pdf"]', (e)->
    e.preventDefault()
    url = $(this).attr('href')
    ga 'send',
      'hitType': 'pageview'
      'page': url.replace(/http:\/\/[^\/]*\//, '/')
      'title': $(this).text()
    setTimeout ->
      location.href = url
    , 300
    return false


  # Greek Transliteration

  $("p,li,dd,dt,td").html (index, html)->
    return html
    .replace(XRegExp('([\\p{InGreek_and_Coptic}\\p{InGreek_Extended}]+)', 'g'), '<span class="greek">$1</span>')

  $('body').on 'click', '.greek', (e)->
    word = $(e.target)

    if word.data("alternate")
      alt = word.data("alternate")
      word.data("alternate", $(e.target).text())
      word.text(alt)

    else
      url = escape('http://transliterate.com/Home/Transliterate?input=' + word.text())
      $.ajax
        url: 'https://jsonp.nodejitsu.com/?url=' + url
        dataType: 'json'
        cache: true
        success: (data)->
          if data.sbl?
            word.data('alternate', word.text())
            word.text(data.sbl)

          else
            word.toggleClass('greek')

  # Topics List Filtering

  letters = unique $(".topics-list li").map(-> $(this).data("letter"))
  key = $("<div class='topics-key'><a data-filter='*' href='#filter-all'>all</a></div>").prependTo(".topics-list")
  key.append($("<a>"+l+"</a>").attr("href", "#filter-#{l}").data("filter", l)) for l in letters
  key.click (e)->
    e.preventDefault()
    f = $(e.target).data('filter')
    $('.topics-list').css('min-height', $('.topics-list').innerHeight())
    if f is "*"
      $(".topics-list li").show()
      setTimeout -> $('.topics-list').css('min-height', 0)
    else
      $(".topics-list li[data-letter!='#{f}']").hide()
      setTimeout ->
        $(".topics-list li[data-letter='#{f}']").show()
        setTimeout -> $('.topics-list').css('min-height', 0)


  # parallel verses

  $('.parallel-verses').each ->
    cols = $(this).find('[class*="col-"]').map ->
      $(this).find('p')
    .get()
    for i in [0..cols[0].length]
      height = Math.max.apply(null, ($(col.get(i)).outerHeight() for col in cols))
      $(col.get(i)).css('min-height', height) for col in cols

  do ->
    page = 1
    wrapper = $('.wrapper-inner')
    count = 0
    pageWidth = wrapper.outerWidth()

    refreshPageCount = ->
      pageWidth = wrapper.outerWidth() + parseFloat(wrapper.css('column-gap'))
      page = 1 + Math.round wrapper.scrollLeft() / pageWidth
      count = Math.ceil wrapper.get(0).scrollWidth / pageWidth
      go page

    go = (page, cb)->
      if typeof cb isnt 'function' then cb = ->
      scroll = (page - 1) * pageWidth
      wrapper.stop()
      wrapper.animate {scrollLeft: scroll}, 100, cb
      $('.current-page').html(page)
      $('.page-count').html(count)

    $('body').on 'click', '.btn.next-page', ->
      if page < count
        go ++page
    $('body').on 'click', '.btn.prev-page', ->
      if page > 1
        go --page

    $('body').on 'swipeleft', ->
      if page < count
        go ++page

    $('body').on 'swiperight', ->
      if page > 1
        go --page

    $('body').on 'taphold', (e)->
      e.preventDefault()
      $('#TOC').addClass('active')

    $('body').on 'tap', (e)->
      $('#TOC').removeClass('active')
     
    $('body').on 'click', '.btn.full-screen', ->
      do enterFullpage

    $('body').on 'click', '.btn.exit-full-screen', ->
      do exitFullpage

    $(window).resize refreshPageCount

    exitFullpage = ->
      $('body').removeClass 'fullscreen'

    enterFullpage = ->
      $('body').addClass 'fullscreen'
      do refreshPageCount

    $(document).keydown (e)->
      if e.which is 27
        $('body').removeClass 'fullscreen'
      if e.which is 37
        if page > 1 then go --page
      if e.which is 39
        if page < count then go ++page

    $('#TOC').on 'click', 'a', (e)->
      if $('body').hasClass('fullscreen')
        e.preventDefault()
        target = $('section'+$(this).attr('href'))
        page = 1 + Math.floor( ( wrapper.scrollLeft() + target.children().first().position().left ) / pageWidth )
        go page


unique = (a)->
  o = {}
  r = []
  o[i] = i for i in a
  r = (i for i of o)

