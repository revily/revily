Revily.Router.reopen
  location: 'history'
  
Revily.Router.map ->
  @route 'login'
    
  @resource 'services', ->
    @route 'new'
    @resource 'service', path: ':service_id', ->
      @route 'edit'
      @route 'incidents'

  @resource 'incidents', ->
    @resource 'incident', path: ':incident_id'

  @resource 'policies', ->
    @route 'new'
    @resource 'policy', path: ':policy_id'

  @resource 'schedules', ->
    @route 'new'
    @resource 'schedule', path: ':schedule_id'

  @resource 'users', ->
    @route 'new'
    @resource 'user', path: ':user_id'

  @resource 'events', ->
    @resource 'event', path: ':event_id'






  # for theme development
  @route 'sink'
