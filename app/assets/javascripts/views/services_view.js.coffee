# Reveille.ServicesView = Ember.View.extend()

Reveille.ServiceView = Ember.View.extend
  templateName: 'services/show'
  tagName: 'li'

  click: (event) ->
    alert "Clicked!"
    console.log event