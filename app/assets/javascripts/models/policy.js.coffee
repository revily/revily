Revily.Policy = DS.Model.extend
  name: DS.attr("string")
  loopLimit: DS.attr("number")
  service: DS.hasMany("service")
