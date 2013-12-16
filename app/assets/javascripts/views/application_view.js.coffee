Revily.ApplicationView = Ember.View.extend
  didInsertElement: ->
    @_super()
    Ember.run.scheduleOnce('afterRender', @, "setMinHeight")

  setMinHeight: ->
    $("#main").css "min-height", $(window).height()
