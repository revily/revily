Revily.ServicesNewRoute = Revily.Route.extend
  model: ->
    @store.createRecord 'service'

  setupController: (controller, model) ->
    controller.set 'model', model
    controller.set 'policies', @store.find('policy')

  deactivate: ->
    model = @modelFor 'servicesNew'
    model.deleteRecord() unless model.get('id')?
