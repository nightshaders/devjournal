angular.module('article-requests', [])
.factory('ReqArticles', ->

  getArticles = ->
    [
      title: "Grumpy wizards make toxic brew for evil Queen and Jack."
      date: "1/1/2001"
      content: "Here's some content"
    ,
      title: "Grumpy wizards make toxic brew for evil Queen and Jack."
      date: "1/2/2001"
      content: "Here some content"
    ]

  {
    getArticles: getArticles
  }
)