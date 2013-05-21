Reveille.SignInRoute = Em.Route.extend
  templateName: 'auth/sign_in'

  model: ->
    Reveille.UserSession.create()

  renderTemplate: ->
    @render()
    @render "auth/sign_in",
      into: "application"
