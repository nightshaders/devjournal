angular.module('blog-articles', [
  'article-requests'
])
.directive('blogArticles', (ReqArticles) ->
  restrict: 'E'
  link: (scope) ->
    scope.articles = ReqArticles.getArticles()
)
.directive('blogArticle', ->
  restrict: 'E'
  templateUrl: '/plain-blog-article'
  scope:
    article: '='
  link: (scope) ->
    console.log('BlogArticle', scope)
)
