Revily.ServicesIndexRoute = Revily.AuthenticatedRoute.extend
  model: ->
    @store.find("service")

  setupController: (controller, model) ->
    controller.set("model", model)

  renderTemplate: (controller) ->
    @render "services/index", { controller: controller }

Revily.ServicesOkRoute = Revily.ServicesIndexRoute.extend
  setupController: (controller, model) ->
    controller.set "model", model.filterBy("health", "ok")

Revily.ServicesWarningRoute = Revily.ServicesIndexRoute.extend
  setupController: (controller, model) ->
    controller.set "model", model.filterBy("health", "warning")

Revily.ServicesCriticalRoute = Revily.ServicesIndexRoute.extend
  setupController: (controller, model) ->
    controller.set "model", model.filterBy("health", "critical")

Revily.ServicesShowRoute = Revily.AuthenticatedRoute.extend
  model: (params) ->
    @store.find("service", params.service_id)

#   setupController: (controller, model) ->
#     console.log controller.ok
#     @controllerFor("services").set("content", model.filterBy("health", "ok"))
#   # model: ->
#     # @super.filterBy("health", "ok")
#     # @store.filter 'service', (service) -> service.get('health') == "ok"

#   renderTemplate: (controller) ->
#     @render "services/index", { controller: controller }

# Revily.ServicesWarningRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
#   model: ->
#     @store.filter 'service', (service) -> service.get('health') == "warning"

#   renderTemplate: (controller) ->
#     @render "services/index", { controller: controller }


# Revily.ServicesCriticalRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
#   model: ->
#     @store.filter 'service', (service) -> service.get('health') == "critical"

#   renderTemplate: (controller) ->
#     @render "services/index", { controller: controller }


# Revily.ServicesEnabledRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
#   model: ->
#     @store.filter 'service', (service) -> service.get('state') == "enabled"

#   renderTemplate: (controller) ->
#     @render "services/index", { controller: controller }


# Revily.ServicesDisabledRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
#   model: ->
#     @store.filter 'service', (service) -> service.get('state') == "disabled"

#   renderTemplate: (controller) ->
#     @render "services/index", { controller: controller }

