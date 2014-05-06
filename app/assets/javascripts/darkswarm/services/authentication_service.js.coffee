Darkswarm.factory "AuthenticationService", (Navigation, $modal, $location)->
  new class AuthenticationService
    selectedPath: "/login"
    constructor: ->
      if $location.path() in ["/login", "/signup", "/forgot"] 
        @open()
    open: =>
      @modalInstance = $modal.open
        templateUrl: 'authentication.html'

      @modalInstance.result.then @close, @close
      Navigation.navigate @selectedPath

    select: (path)=>
      @selectedPath = path
      Navigation.navigate @selectedPath

    active: Navigation.active

    close: ->
      Navigation.navigate "/"
