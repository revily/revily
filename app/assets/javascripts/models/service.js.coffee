Reveille.Service = DS.Model.extend
  name: DS.attr('string')
  autoResolveTimeout: DS.attr('number')
  acknowledgeTimeout: DS.attr('number')
  currentStatus: DS.attr('string')
  # escalationPolicy: DS.belongsTo('Reveille.EscalationPolicy')