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

app.controller 'MainCtrl', ['$scope' ($scope) ->

  chrome.bookmarks.getRecent 5000, (data) ->
    $scope.bookmarks = data
  /*

  chrome.bookmarks.getTree (data) ->
    # Only get first level bookmarks
    _.forEach data[0].children[0].children, (data, index) ->
      unless data.children
        return $scope.bookmarks.push(data)

    $scope.$apply()
  */

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