Reveille.UsersShowRoute = Em.Route.extend
  serialize: (model) ->
    user_id: model.get('param')

  model: (param) ->
    Reveille.User.find(param.user_id) if Reveille.Auth.get('signedIn')