Revily.DashboardController = Ember.Controller.extend
  actions:
    inspect: ->
      window.Session = @get("session")
