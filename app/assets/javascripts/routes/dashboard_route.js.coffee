Reveille.DashboardRoute = Ember.Route.extend
  renderTemplate: ->
    @render()
    @render 'application/header', into: 'application', outlet: 'header'
    @render 'application/footer', into: 'application', outlet: 'footer'
    @render 'application/sidebar', into: 'application', outlet: 'sidebar'
