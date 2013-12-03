Revily.ServicesController = Ember.ArrayController.extend
  isOk: Ember.computed.equal "health", "ok"
  isWarning: Ember.computed.equal "health", "warning"
  isCritical: Ember.computed.equal "health", "critical"

  isEnabled: Ember.computed.equal "state", "enabled"
  isDisabled: Ember.computed.equal "state", "disabled"

Revily.ServicesIndexController = Revily.ServicesController.extend()

  # services: ->
  #   @store.find("service")

  # ok: (->
  #   @get("content").filterBy("health", "ok")
  # ).property("content.@each.health")

  # warning: (->
  #   @get("content").filterBy("health", "warning")
  # ).property("content.@each.health")

  # critical: (->
  #   @get("content").filterBy("health", "critical")
  # ).property("content.@each.health")

  # currentFilter: "all"

  # # filterByHealth: (health) ->
  #   # @get(health)

  # actions:
  #   setFilteredItems: ->
  #     filter = @get("currentFilter")
  #     if filter == "all"
  #       @set "content", @get("")
  #       true
  #     else
  #       @set "content", @get(filter)
  #       true
