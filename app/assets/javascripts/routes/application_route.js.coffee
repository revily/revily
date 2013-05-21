Reveille.ApplicationRoute = Ember.Route.extend
  activate: ->
    $(document).attr('title', 'Reveille')
    
  renderTemplate: ->
    @render()
    @render 'application/header', into: 'application', outlet: 'header'
    @render 'application/footer', into: 'application', outlet: 'footer'
    @render 'application/sidebar', into: 'application', outlet: 'sidebar'
