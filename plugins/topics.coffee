spawn = require('child_process').spawn
fs = require 'fs'
tmp = require 'tmp'

module.exports = (env, callback)->

  env.helpers.getSortedTopics = (contents)->
    Object.keys(contents.topics).map (a)-> contents.topics[a]
    .filter (a)-> a.template == 'topic.jade' and (!a.metadata.language? or a.metadata.language is 'en')
    .sort (a,b)->
      titleA = a.metadata.indexTitle || a.title
      titleB = b.metadata.indexTitle || b.title
      titleA.trim().toLowerCase().localeCompare(titleB.trim().toLowerCase(), null, { sensitivity: "base" })
  env.helpers.getNextPrevTopics = (thisTopic, contents)->
    topics = env.helpers.getSortedTopics(contents)
    for topic, i in topics
      if thisTopic is topic
        return {
          prev: if i > 0 then topics[i-1]
          next: if topics.length > ( i + 1 ) then topics[i+1]
        }
    return {}

  class TopicPdf extends env.plugins.Page
    constructor: (@topic) ->

    getFilename: ->
      @topic.getFilename().replace /\.html$/, '.pdf'

    getView: -> (env, locals, contents, templates, callback) =>
      tmp.file { postfix: '.pdf' }, (err, path, fd, cleanupCallback)=>
        if err then throw err
        error = ''

        pandoc = spawn 'pandoc', [
          '--from=markdown'
          '--standalone'
          '--latex-engine=xelatex'
          '--smart'
          '--output=' + path
          '--data-dir=' + env.resolvePath('pandoc')
          @topic.filepath.full
        ], { cwd: env.resolveContentsPath('topics') }
        
        pandoc.stderr.on 'data', (data)->
          error += data

        pandoc.on 'close', (code) ->
          msg = ''
          if code isnt 0
            msg += 'pandoc exited with code ' + code + (if error then ': ' else '.')
          if error
            msg += error
          if msg then callback(new Error(msg))

          callback null, fs.createReadStream path, {fd:fd}

        do pandoc.stdin.end

  env.registerGenerator 'topicPDFs', (contents, callback)->
    rv = {pdfs:{}}
    for topic, i in env.helpers.getSortedTopics(contents)
      pdf = new TopicPdf topic
      rv.pdfs[pdf.getFilename().split('/').pop()] = pdf
      topic.pdf = '/' + pdf.getFilename()

    callback null, rv


  do callback
