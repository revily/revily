Revily.LoginRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.setProperties
      identification: undefined
      password: undefined
      errorMessage: undefined
