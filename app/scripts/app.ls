app = angular.module 'BookmarksManagerApp', ['ui.router']

app.config ($compileProvider, $stateProvider, $urlRouterProvider, $locationProvider) ->

  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome-extension):/)

  $urlRouterProvider.otherwise '/bookmarks'

  $stateProvider
    .state 'bookmarks',
      abstract: true
      url: '/bookmarks'
      templateUrl: '/app/templates/bookmarks/index.html'
    .state 'bookmarks.list',
      url: ''
      templateUrl: '/app/templates/bookmarks/list.html'

app.controller 'MainCtrl', ['$sce', '$scope' ($sce, $scope) ->

  $scope.trustSrc = (src) ->
    return $sce.trustAsResourceUrl(src)

  /*
  chrome.bookmarks.getRecent 100, (data) ->
    $scope.bookmarks = data
  */
  chrome.bookmarks.getTree (data) ->
    $scope.bookmarks = data[0].children[0].children

  /*

  q = "ellen"

  chrome.bookmarks.search q, (data) ->
    console.log data

  bookmark = {
    parentId: null
    title: "My test bookmark"
    url: "http://tracklistapp.com"
  }

  chrome.bookmarks.create bookmark, (result) ->
    console.log result

  */

]
