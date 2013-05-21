Reveille.SignInController = Ember.ObjectController.extend
  
  lolwut: ->
    console.log "lolwut"

  signIn: ->
    console.log "signing in via controller"
    Reveille.Auth.signIn
      data:
        email: @get('email')
        password: @get('password')
