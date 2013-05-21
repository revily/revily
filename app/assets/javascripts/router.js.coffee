Reveille.Router.reopen
  location: 'history'

Reveille.Router.map ->
  @resource 'services', ->
    @route 'new'
    @route 'show', path: '/:service_id'
    @route 'edit', path: '/:service_id/edit'

  @resource 'policies', ->
    @route 'new'
    @route 'show', path: '/:policy_id'
    @route 'edit', path: '/:policy_id/edit'

  @resource 'incidents', ->
    @route 'new'
    @route 'show', path: '/:incident_id'
    @route 'edit', path: '/:incident_id/edit'

  @resource 'schedules', ->
    @route 'new'
    @route 'show', path: '/:schedule_id'
    @route 'edit', path: '/:schedule_id/edit'

  @resource 'users', ->
    @route 'new'
    @route 'show', path: '/:user_id'
    @route 'edit', path: '/:user_id/edit'

  @route 'sign_in'
  @route 'sign_up'
