Revily.OffCanvasView = Ember.View.extend
  layoutName: "off_canvas_layout"
  
  open: ->
    $(@).closest(".off-canvas-wrap").addClass("move-left")

  close: ->
    $(".off-canvas-wrap").removeClass("move-left")
