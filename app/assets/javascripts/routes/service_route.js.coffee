Revily.ServiceRoute = Revily.Route.extend
  model: (params) ->
    @store.find("service", params.service_id)

  setupController: (controller, model) ->
    controller.set "model", model

