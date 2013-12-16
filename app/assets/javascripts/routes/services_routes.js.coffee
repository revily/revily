Revily.ServicesIndexRoute = Revily.Route.extend
  model: ->
    @store.find("service")
    # results.filterBy("isNew", false)

  setupController: (controller, model) ->
    controller.set("model", model)

  renderTemplate: (controller) ->
    @render "services/index" #, { controller: controller }
    # @render "services/new", into: "application", outlet: "right", controller: "servicesNew"
    
Revily.ServicesOkRoute = Revily.ServicesIndexRoute.extend
  setupController: (controller, model) ->
    controller.set "model", model.filterBy("health", "ok")

Revily.ServicesWarningRoute = Revily.ServicesIndexRoute.extend
  setupController: (controller, model) ->
    controller.set "model", model.filterBy("health", "warning")

Revily.ServicesCriticalRoute = Revily.ServicesIndexRoute.extend
  setupController: (controller, model) ->
    controller.set "model", model.filterBy("health", "critical")

Revily.ServicesDisabledRoute = Revily.ServicesIndexRoute.extend
  setupController: (controller, model) ->
    controller.set "model", model.filterBy("health", "disabled")

Revily.ServicesShowRoute = Revily.Route.extend
  model: (params) ->
    @store.find("service", params.service_id)

  setupController: (controller, model) ->
    controller.set "model", model

