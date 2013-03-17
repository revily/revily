do ($ = jQuery) ->
  $ ->
    # modal dialogs
    $('div.bootstrap-modal').modal()
    $('div.bootstrap-modal').modal('hide').addClass('fade')
    
    # modal-cancel-button
    $("a.bootstrap-modal-cancel-button").click (event) ->
      $(event.target).closest("div.modal").modal("hide")

    # modal-form-submit-button
    $("a.modal-form-submit-button").click (event)->
      $(event.target).closest("div.modal").find("form").trigger('submit.rails')