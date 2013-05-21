jQuery ->
  resetForm = (element) ->
    $(element)[0].reset()
    $(element)
      .resetClientSideValidations()
      .hide("blind", {}, 500)
    $("#{element}_button")
      .text("Create New Policy")
      .switchClass("btn-danger", "btn-primary")

  $(document).on 'change', "#rules select", ->
    optgroup = $("#rules :selected").parent()
    label = $(optgroup).attr('label')
    $(this).closest('select').siblings('input[type=hidden]').val(label)

  $("#new_escalation_policy_button").click ->
    if $("#new_escalation_policy").is(':hidden')
      $(this)
        .text("Cancel New Policy")
        .switchClass("btn-primary", "btn-danger")
      $("#new_escalation_policy").show "blind", {}, 500, ->
        $("#new_escalation_policy").enableClientSideValidations();
    else
      resetForm("#new_escalation_policy")

  $("#new_escalation_policy").on 'ajax:success', (event, xhr, status) ->
    resetForm("#new_escalation_policy")

  $("#new_escalation_policy").on 'ajax:error', (event, xhr, status) ->
    errors = $.parseJSON(xhr.responseText).errors

    for attribute, error of errors
      element = $("input#escalation_policy_#{attribute}")
      element.closest(".control-group").addClass("error")
      element.closest(".controls").append("<span class='help-inline'>#{error[0]}</span>")

  $('.policy a[data-method=delete]').on 'ajax:success', (event, data, status, xhr) ->
    $(this).parents('tr.policy').hide('highlight') 

  # $('a.add-rule').tooltip
  #   title: "Add a new rule."

  # $('a.delete-policy').tooltip
  #   title: "Delete this policy."
