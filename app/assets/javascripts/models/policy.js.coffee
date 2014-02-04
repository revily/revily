Revily.Policy = DS.Model.extend
  name: DS.attr("string")
  loopLimit: DS.attr("number")

  services: DS.hasMany("service")
  policyRules: DS.hasMany("policyRule")
