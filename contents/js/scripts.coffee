$ = jQuery

$(document).ready ->

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

unique = (a)->
  o = {}
  r = []
  o[i] = i for i in a
  r = (i for i of o)

