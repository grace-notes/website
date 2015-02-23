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
          prev: if i > 1 then topics[i-1]
          next: if topics.length > i + 1 then topics[i+1]
        }


  do callback
