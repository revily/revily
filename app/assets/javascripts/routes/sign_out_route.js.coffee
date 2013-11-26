Revily.SignOutRoute = Ember.Route.extend
  beforeModel: ->
    @get("session").destroy()
