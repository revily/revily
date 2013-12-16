Revily.ServicesController = Revily.ArrayController.extend()

Revily.ServicesIndexController = Revily.ServicesController.extend()

Revily.ServicesShowController = Revily.ObjectController.extend()

Revily.ServicesNewController = Revily.ObjectController.extend
  policies: (-> @store.find "policy").property("policies")
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
