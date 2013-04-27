Reveille.ServicesRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set('services', model)

Reveille.ServicesIndexRoute = Reveille.ServicesRoute.extend
  model: ->
    Reveille.Service.find()
  setupController: (controller, model) ->
    controller.set('services', model)

Reveille.ServicesShowRoute = Ember.Route.extend
  model: (params) ->
    Reveille.Service.find(params.service_id)
  setupController: (controller, model) ->
    controller.set('service', model)
    @controllerFor('application').set('currentRoute', 'services')