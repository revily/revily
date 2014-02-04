Revily.ServicesIndexController = Revily.ArrayController.extend
  filterName: "all"

  allFilter:                -> true
  okFilter:       (service) -> service.get("health") is "ok"
  warningFilter:  (service) -> service.get("health") is "warning"
  criticalFilter: (service) -> service.get("health") is "critical"
  disabledFilter: (service) -> service.get("health") is "disabled"

  filtered: (->
    filterName = @get("filterName")
    filterFunc = @get(filterName + "Filter")

    @filter(filterFunc).filterBy("isNew", false)
  ).property("content.@each.health", "filterName", "isNew")

  isAll:      (-> @get("filterName") is "all").property("filterName")
  isOk:       (-> @get("filterName") is "ok").property("filterName")
  isWarning:  (-> @get("filterName") is "warning").property("filterName")
  isCritical: (-> @get("filterName") is "critical").property("filterName")
  isDisabled: (-> @get("filterName") is "disabled").property("filterName")

  actions:
    setFilterName: (name) ->
      @logger.debug "set filterName to #{name}"
      @set("filterName", name)
