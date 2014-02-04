Revily.Incident = DS.Model.extend
  message: DS.attr('string')
  description: DS.attr('string')
  details: DS.attr('string')
  state: DS.attr('string')
  key: DS.attr('string')
  escalationLoopCount: DS.attr('number')
  # Timestamps
  triggeredAt: DS.attr('date')
  acknowledgedAt: DS.attr('date')
  resolvedAt: DS.attr('date')
  # Associations
  service: DS.belongsTo('service')
  currentUser: DS.belongsTo('user')
  currentPolicyRule: DS.belongsTo('policy_rule')
