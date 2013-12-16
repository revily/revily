Revily.ServicesNewRoute = Revily.Route.extend
  model: ->
    @store.createRecord("service")

  actions: 
    save: ->
      console.log @modelFor("servicesNew")
      @get("model").save().then ->
        @transitionTo("services")
      
    cancel: ->
      @get("model").deleteRecord().then ->
        @transitionTo("services")
          
