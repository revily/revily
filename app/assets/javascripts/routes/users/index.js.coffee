Reveille.UsersIndexRoute = Em.Route.extend
  model: ->
    Reveille.User.find() if Reveille.Auth.get('signedIn')