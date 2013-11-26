Revily.CurrentUserController = Ember.ObjectController.extend
  content: null

  retrieveCurrentUser: ->
    controller = @
    Ember.$.getJSON "/api/me", (data) ->
      @store.load("user", data)
      currentUser = @store.find(data.id)
      controller.set("content", currentUser)
