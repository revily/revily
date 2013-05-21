@Reveille.ServicesShowRoute = Ember.Route.extend Reveille.Auth.AuthRedirectable,
  model: (params) ->
    Reveille.Service.find(params.service_id) if Reveille.Auth.get('signedIn')
    
  setupController: (controller, model) ->
    controller.set('content', model)
