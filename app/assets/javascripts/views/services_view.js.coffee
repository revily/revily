@Reveille.reopen
  ServicesView: Ember.CollectionView.extend
    templateName: 'services/index'

  ServicesListView: Ember.CollectionView.extend
    # elementId: 'services'
    tagName: 'tr'
    # controller: 'services'

    emptyView: Ember.View.extend
      template: Ember.Handlebars.compile('<div class="loading"><span>Loading</span></div>')

    itemViewClass: Ember.View.extend
      serviceBinding: 'content'
      classNames: ['service']
      classNameBindings: ['selected']
      selected: (->
        @get('content') == @get[controller.selectedService]
      ).property('controller.selectedService')

  ServiceView: Ember.View.extend
    templateName: 'services/show'
    servicesBinding: 'controllers.services'
    classNameBindings: ['controller.isLoading:loading']


  # ServicesEmptyView: Ember.View.extend
    # template: ''