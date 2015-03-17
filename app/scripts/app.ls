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

app.directive 'checkUrl' ->
  link: (scope, element, attrs) ->

    #Frames are not allowed on these websites
    sites = [
      {'name':'github.com'}
      {'name':'stackoverflow.com'}
      {'name':'programmers.stackexchange.com'}
    ]

    #Inform user that frames are not allowed for a given url
    element.parent().bind 'mouseenter', (event) ->

      url = scope.bookmark.url.split( '/' )
      siteName = url[2]

      if _.result _.find(sites
        'name': siteName
        ), 'name'
        return element.addClass('no-frames-allowed')

app.directive 'visited', ->
  link: (scope, element, attrs) ->
    element.bind 'click', (event) ->
      event.preventDefault()
      element.addClass('visited')

app.controller 'MainCtrl', ['$sce', '$scope' ($sce, $scope) ->

  $scope.bookmarks = []
  $scope.clicks = []

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
