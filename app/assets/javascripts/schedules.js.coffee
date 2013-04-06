$(document).on 'click', 'form .remove_fields', (incident) ->
  $(this).prev('input[type=hidden]').val('1')
  $(this).closest('fieldset').hide()
  incident.princidentDefault()

$(document).on 'click', 'form .add_fields', (incident) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $(this).before($(this).data('fields').replace(regexp, time))
  incident.princidentDefault()

$ ->
  $('.datepicker').datepicker(dateFormat: 'yy-mm-dd')

$ ->
  $('[data-behavior~=datepicker]').datepicker()