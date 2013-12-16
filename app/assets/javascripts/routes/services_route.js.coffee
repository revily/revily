Revily.ServicesRoute = Revily.Route.extend
  renderTemplate: (controller, model) ->
    @render "services" #, { controller: controller }
    # @render "services/new", into: "application", outlet: "right", controller: "servicesNew"
    
