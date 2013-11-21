Revily.Service = DS.Model.extend
  name: DS.attr("string")
  autoResolveTimeout: DS.attr("string")
  acknowledgeTimeout: DS.attr("string")
  incidents: DS.hasMany("incident")
  policy: DS.belongsTo("policy")
