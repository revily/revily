Revily.SubNavView = Ember.View.extend

  activateTab: (tab) ->
    receivedTabs = @get("tabs").findProperty("active")
    receivedTabs.set("active", false)
    tab.set("active", true)
