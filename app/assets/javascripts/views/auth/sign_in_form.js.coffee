Reveille.AuthSignInFormView = Ember.View.extend
  templateName: 'auth/sign_in'

  email: null
  password: null

  submit: (event, view) ->
    event.preventDefault()
    event.stopPropagation()
    Reveille.Auth.signIn
      data:
        email: @get 'email'
        password: @get 'password'