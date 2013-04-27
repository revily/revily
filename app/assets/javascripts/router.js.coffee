Reveille.Router.reopen
  location: 'history'

Reveille.Router.map ->
  @resource 'services', ->
    @route 'new'
    @route 'edit',
      path: '/:service_id/edit'
    @route 'show',
      path: '/:service_id'

  @resource 'policies', ->
    @route 'new'
    @route 'edit',
      path: '/:policy_id/edit'
    @route 'show',
      path: '/:policy_id'

  @resource 'incidents', ->
    @route 'new'
    @route 'edit',
      path: '/:incident_id/edit'
    @route 'show',
      path: '/:incident_id'

  @resource 'schedules', ->
    @route 'new'
    @route 'edit',
      path: '/:schedule_id/edit'
    @route 'show',
      path: '/:schedule_id'

  @resource 'users', ->
    @route 'new'
    @route 'edit',
      path: '/:user_id/edit'
    @route 'show',
      path: '/:user_id'
