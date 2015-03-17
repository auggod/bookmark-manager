chrome.webRequest.onHeadersReceived.addListener ((info) ->
  headers = info.responseHeaders
  i = headers.length - 1
  while i >= 0
    header = headers[i].name.toLowerCase()
    if header == 'x-frame-options' or header == 'frame-options'
      headers.splice i, 1
      # Remove header
    --i
  { responseHeaders: headers }
), {
  urls: [ '*://*/*' ]
  types: [ 'sub_frame' ]
}, [
  'blocking'
  'responseHeaders'
]

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

  $scope.bookmarks = []

  $scope.trustSrc = (src) ->
    return $sce.trustAsResourceUrl(src)

  $scope.showView = (url) ->
    $scope.viewUrl = url

  chrome.bookmarks.getRecent 1000, (data) ->
    $scope.bookmarks = data
    $scope.viewUrl = $scope.bookmarks[0].url
    $scope.$apply()


  /*
  chrome.bookmarks.getTree (data) ->
    console.log data[0].children[0].children
    $scope.bookmarks = data[0].children[0].children
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
