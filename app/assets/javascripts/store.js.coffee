# http://emberjs.com/guides/models/using-the-store/

# Revily.ApplicationAdapter = DS.Store.extend
Revily.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: "api"

# Revily.Store = DS.Store.extend
#   # Override the default adapter with the `DS.ActiveModelAdapter` which
#   # is built to work nicely with the ActiveModel::Serializers gem.
#   adapter: '_ams'
#   namespace: 'api'
