module.exports = (env, callback)->

  env.helpers.getSortedTopics = (contents, lang)->
    locale = locale || 'en'
    Object.keys(contents.topics).map (a)-> contents.topics[a]
    .filter (a)-> a.template == 'topic.jade' and (!a.metadata.language? or a.metadata.language is 'en')
    .sort (a,b)->
      titleA = (a.metadata.indexTitle || a.title || '').trim().toLowerCase()
      titleB = (b.metadata.indexTitle || b.title || '').trim().toLowerCase()
      titleA.localeCompare(titleB, lang, { sensitivity: "base" })
  env.helpers.getNextPrevTopics = (thisTopic, contents)->
    topics = env.helpers.getSortedTopics(contents)
    for topic, i in topics
      if thisTopic is topic
        return {
          prev: if i > 0 then topics[i-1]
          next: if topics.length > ( i + 1 ) then topics[i+1]
        }
    return {}

  do callback
