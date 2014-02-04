Revily.PolicyRule = DS.Model.extend
  # name: DS.attr("string")
  # loopLimit: DS.attr("number")

  policy: DS.belongsTo("policy")
