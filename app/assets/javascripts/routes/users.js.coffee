Reveille.UsersRoute = Em.Route.extend
  model: ->
    if Reveille.Auth.get('signedIn')
      Reveille.User.find()