# DS.RESTAdapter.reopen
  # namespace: 'api'

# Reveille.Adapter = DS.RESTAdapter.extend
  # namespace: 'api'

Reveille.Store = DS.Store.extend
  revision: 12
  adapter: DS.RESTAdapter.create
    namespace: 'api'
  # adapter: Reveille.Adapter
