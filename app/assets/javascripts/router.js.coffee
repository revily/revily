# For more information see: http://emberjs.com/guides/routing/

Revily.Router.map ()->
  @resource 'dashboard', path: '/'
  @resource 'services', ->
    @resource 'index'

