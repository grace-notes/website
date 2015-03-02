spawn = require('child_process').spawn
fs = require 'fs'
async = require 'async'
tmp = require 'tmp'

q = async.queue((task, callback) =>
  [pdf, env, locals, contents, templates] = task.args
  pdf._getView env, locals, contents, templates, callback
, 4)

module.exports = (env, callback)->

  class TopicPdf extends env.plugins.Page
    constructor: (@topic) ->

    getFilename: ->
      @topic.getFilename().replace /\.html$/, '.pdf'

    getView: => (env, locals, contents, templates, callback) =>
      q.push { args: [@, env, locals, contents, templates] }, callback

    _getView: (env, locals, contents, templates, callback) =>
      tmp.file { template: '/tmp/pandoc-XXXXXXX.pdf' }, (err, path, fd, cleanupCallback)=>
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
    rv = {topics:{pdf:{}}}
    for topic, i in env.helpers.getSortedTopics(contents)
      pdf = new TopicPdf topic
      rv.topics.pdf[pdf.getFilename().split('/').pop()] = pdf
      topic.pdf = '/' + pdf.getFilename()

    callback null, rv


  do callback
