Reveille.ServicesIndexRoute = Ember.Route.extend Reveille.Auth.AuthRedirectable,
  # activate: ->
    # @transitionTo('sign_in') unless Reveille.Auth.get('signedIn')
  model: ->
    Reveille.Service.find() if Reveille.Auth.get('signedIn')
  
  # setupController: (controller, model) ->
    # controller.set('content', model)
  
  renderTemplate: ->
    @render()
    @render "services/_sidebar",
      into: "application"
      outlet: "sidebar"