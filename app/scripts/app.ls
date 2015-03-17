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

app = angular.module 'BookmarksManagerApp', []

app.config ($compileProvider) ->

  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome-extension):/)

app.directive 'checkUrl' ->
  link: (scope, element, attrs) ->

    #Frames are not allowed on these websites
    sites = [
      {'name':'github.com'}
      {'name':'stackoverflow.com'}
      {'name':'programmers.stackexchange.com'}
      {'name':'medium.com'}
    ]
    #Inform user that frames are not allowed for a given url
    isFrameNotAllowed =  _.result _.find(sites
      'name': scope.bookmark.url.split( '/' )[2]
      ), 'name'

    element.bind 'mouseenter', (event) ->
      element.addClass('no-frames-allowed') if isFrameNotAllowed
      element.bind 'mouseleave', (event) ->
        element.removeClass('no-frames-allowed')

    element.bind 'click', (event) ->
      return window.open scope.bookmark.url,'_blank' if isFrameNotAllowed
      scope.showView(scope.bookmark.url)

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
    $scope.$apply()

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
