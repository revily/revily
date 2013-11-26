Revily.FilterItemView = Ember.View.extend
  tagName: "dd"
  templateName: "views/filter_item"
  classNames: ["filter-item"]
  classNameBindings: ["isActive:active"]

  text: null
  isActive: false

  click: ->
    controller = @get("controller")
    controller.set "currentFilter", @get("text").decamelize()
    # controller.send("filter")

