Revily.Contact = DS.Model.extend
  address: DS.attr("string")
  label: DS.attr("string")
  type: DS.attr("string")
  user: DS.belongsTo("user")
