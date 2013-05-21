Reveille.Auth = Em.Auth.create
  signInEndPoint: '/api/users/sign_in'
  signOutEndPoint: '/api/users/sign_out'

  tokenKey: 'auth_token'
  tokenKeyId: 'user_id'
  tokenLocation: 'authHeader'

  # modules: [ 'emberData', 'rememberable', 'authRedirectable', 'actionRedirectable' ]
  modules: [ 'emberData', 'authRedirectable', 'actionRedirectable' ]

  # rememberable:
  #   tokenKey: 'remember_token'
  #   period: 7
  #   autoRecall: true

  userModel: 'Reveille.User'

  authRedirectable:
    route: 'sign_in'

  actionRedirectable: 
    signOutRoute: 'sign_in'
    signInRoute: 'index'
