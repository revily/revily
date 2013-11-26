Revily.LoginController = Ember.Controller.extend Ember.SimpleAuth.LoginControllerMixin,
  tokenRequestOptions: (username, password) ->
    params =
      client_id: App.client_id
      client_secret: App.client_secret
      grant_type: "password"
      username: username
      password: password

    type: "POST",
    data: JSON.stringify params
    contentType: "application/json"
  
  actions:
    loginFailed: (xhr, status, error) ->
      response = JSON.parse(xhr.responseText)
      @set("errorMessage", response.error)
    # loginSucceeded: ->
    #   attemptedTransition = @get('session.attemptedTransition')
    #   if attemptedTransition
    #     attemptedTransition.retry()
    #     @set('session.attemptedTransition', undefined)
    #   else
    #     @transitionToRoute(Ember.SimpleAuth.routeAfterLogin)
      
