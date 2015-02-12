$ = jQuery

patterns = {
  "Genesis": "Gen(esis)?"
  "Exodus": "Ex(od?(us)?)?"
  "Leviticus": "Lev(iticus)?"
  "Numbers": "Nu(m(bers)?)?"
  "Deuteronomy": "(Dt|Deu?t?(eronomy)?)"
  "Joshua": "Jos?h?(ua)?"
  "Judges": "(Jud(g(es?)?)?|Jgs)"
  "Ruth": "Ru(th?)?"
  "1 Samuel": "(1(st)?|I) ?Sa?(m(uel)?)?"
  "2 Samuel": "(2(nd)?|II) ?Sa?(m(uel)?)?"
  "1 Kings": "(1(st)?|I) ?Ki?(ngs)?"
  "2 Kings": "(2(nd)?|II) ?Ki?(ngs)?"
  "1 Chronicles": "(1(st)?|I) ?Chr?(on(icles)?)?"
  "2 Chronicles": "(2(nd)?|II) ?Chr?(on(icles)?)?"
  "Ezra": "Ez(ra)?"
  "Nehemiah": "Ne(h(emiah)?)?"
  "Esther": "Es(t(her)?)?"
  "Job": "Jo?b"
  "Psalms": "Ps(alms?)?"
  "Proverbs": "Pro(v(erbs)?)?"
  "Ecclesiastes": "Ecc(lesiastes)?"
  "Song of Solomon": "(Sg|Song( of Songs)?|Song of Sol(omon)?)"
  "Isaiah": "Is(a(iah)?)?"
  "Jeremiah": "Je(r(emiah)?)?"
  "Lamentations": "La(m(entations)?)?"
  "Ezekiel": "Ez(e(k(iel)?)?)?"
  "Daniel": "Da(n(iel)?)?"
  "Hosea": "Ho(s(ea)?)?"
  "Joel": "(Joel|Jl)"
  "Amos": "Am(os)?"
  "Obadiah": "Ob(a(d(iah)?)?)?"
  "Jonah": "Jon(ah)?"
  "Micah": "Mi(c(ah)?)?"
  "Nahum": "Na(h(um)?)?"
  "Habakkuk": "(Ha(b(akkuk)?)?|Hb)"
  "Zephaniah": "Zep(h(aniah)?)?"
  "Haggai": "Ha?g(gai)?"
  "Zechariah": "Zec(h(ariah)?)?"
  "Malachi": "Mal(achi)?"
  "Matthew": "Ma?t(t(hew)?)?"
  "Mark": "M(ar)?k"
  "Luke": "(Luke|Lk|Lu)"
  "John": "(John|Jn)"
  "Acts": "(Acts|Ac|Act)"
  "Romans": "Ro(m(ans)?)?"
  "1 Corinthians": "(1(st)?|I) ?Cor(inthians)?"
  "2 Corinthians": "(2(nd)?|II) ?Cor(inthians)?"
  "Galatians": "Ga(l(atians)?)?"
  "Ephesians": "Eph?(esians)?"
  "Philippians": "Ph(il?)?(ippians)?"
  "Colossians": "Col(ossians)?"
  "1 Thessalonians": "(1(st)?|I) ?Th(ess(alonians)?)?"
  "2 Thessalonians": "(2(nd)?|II) ?Th(ess(alonians)?)?"
  "1 Timothy": "(1(st)?|I) ?Ti(m(othy)?)?"
  "2 Timothy": "(2(nd)?|II) ?Ti(m(othy)?)?"
  "Titus": "Tit(us)?"
  "Philemon": "(Philem(on)?|Phlm)"
  "Hebrews": "Heb(rews)?"
  "James": "Ja(me)?s"
  "1 Peter": "(1(st)?|I) ?(Pet(er)?|Pt)"
  "2 Peter": "(2(nd)?|II) ?(Pet(er)?|Pt)"
  "1 John": "(1(st)?|I) ?(John|Jn)"
  "2 John": "(2(nd)?|II) ?(John|Jn)"
  "3 John": "(3(rd)?|III) ?(John|Jn)"
  "Jude": "(Jude|Jud|Jd)"
  "Revelation": "Re(v(elation)?)?"
}

normalizeRef = (t)->
  t = t.trim()
  t = t.replace(RegExp("\\b"+pat+"\\b\\.?"), name) for name, pat of patterns
  t = t.replace(/(\s|&nbsp;)+/g, '+')
  return t

allBooks = '(' + ("\\b"+pattern for book, pattern of patterns).join('|') + ')'
allBooksRegEx = RegExp('('+allBooks+'\\b\\.?(&nbsp;|\\s)*[0-9.]([a-cf0-9:—–-]|,\\s?|&nbsp;)*(;((\\s|&nbsp;)?[0-9]*:([0-9—–-]|,\\s?)*))*)\\b(?![^<]*</a>)', 'gi')

replacement = (match, p1, p2, p3)->
  stdname = normalizeRef(match)
  return "<a target=\"_blank\" href=\"http://www.biblegateway.com/passage/?search=#{stdname}&interface=print\" data-bibleref=\"#{stdname}\">#{match}</a>"

$(document).ready ->

  $("body").on "mouseover", "p,li,dd,dt,td,q,blockquote", (e)->
    if $(this).data("bibleref") is "finished" then return

    $(this).html (index, html)->
      return html.replace(allBooksRegEx, replacement)
    $(this).data("bibleref", "finished")


