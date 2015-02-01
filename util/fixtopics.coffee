fs = require 'fs'
topics = require './topics'

metafy = (topic)->[
    "title: " + JSON.stringify topic.title.trim()
    "pdf: " + JSON.stringify topic.pdf
    "description: " + JSON.stringify topic.description.trim()
    "template: lesson.jade"
  ].join("\n")

fixmeta = (topic)->
  return unless topic.filename?.length > 0
  filename = "./contents/topics/" + topic.filename
  fs.readFile filename, 'utf8', (err, content)->
    if err
      content = ""
    else
      content = content.replace(/---\n([\s\S]*)\n---\n([\s\S]*)/, "$2")
    meta = metafy topic
    fs.writeFile filename, ["---", meta, "---", content].join("\n"), (err)->
      if err then console.log err, filename

fixmeta topic for topic in topics
