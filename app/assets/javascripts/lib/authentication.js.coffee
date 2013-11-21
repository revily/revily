Ember.Application.initializer
  name: "authentication"

  initialize: (container, application) ->
    Ember.SimpleAuth.setup container, application,
      serverTokenEndpoint: "/oauth/token"
      # loginRoute: "sign_in"
      routeAfterLogin: "dashboard"
      routeAfterLogout: "login"

# Ember.Application.initializer
#   name: "currentUser"

#   initialize: (container, application) ->
#     $ ->
#       store = container.lookup("store:main")
#       Ember.$.getJSON "/api/me", (data) ->
#         user = store.load("user", data).find("user", data.id)
#         console.log(user)
#         controller = container.lookup("controllers:currentUser").set("content", user)
#         container.typeInjection("controller", "currentUser", "controller:currentUser")
