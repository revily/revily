Revily.ServicesIndexRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: ->
    @store.find('service')

  setupController: (controller) ->
    controller.set("title", "Services")
    # @_super
