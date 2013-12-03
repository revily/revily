Revily.Service = DS.Model.extend
  name: DS.attr("string")
  autoResolveTimeout: DS.attr("number")
  acknowledgeTimeout: DS.attr("number")
  health: DS.attr("string")
  state: DS.attr("string")
  incidentCounts: DS.attr()
  
  policy: DS.belongsTo("policy")
  incidents: DS.hasMany("incident")
  events: DS.hasMany("event")

  formattedAcknowledgeTimeout: (->
    moment.duration(@get("acknowledgeTimeout"), "minutes").humanize()
  ).property("acknowledgeTimeout")
  formattedAutoResolveTimeout: (->
    moment.duration(@get("autoResolveTimeout"), "minutes").humanize()
  ).property("autoResolveTimeout")

  healthIconClass: (->
    switch @get("health")
      when "ok" then "fa-check-circle"
      when "warning" then "fa-exclamation-circle"
      when "critical" then "fa-times-circle"
      when "disabled" then "fa-minus-circle"
      else "fa-question-circle"
  ).property("health")
