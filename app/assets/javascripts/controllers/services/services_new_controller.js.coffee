Revily.ServicesNewController = Revily.ObjectController.extend
  hasPolicies: Em.computed.gte('policies.length', 1).cacheable()

  errors: null

  actions:
    save: (service) ->
      console.log "services.new#cancel"
      # @get("model").save()
      self = @
      service.save()
      .then(->
        self.transitionToRoute("services")
      ).fail((e)->
        self.set("errors", e.errors)
        self.set("isValid", false)
      )
    cancel: (service) ->
      console.log "services.new#cancel"

      # service.deleteRecord()
      @transitionToRoute("services")
