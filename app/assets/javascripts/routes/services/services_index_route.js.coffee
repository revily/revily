Revily.ServicesIndexRoute = Revily.Route.extend
  model: ->
    @store.find("service")
