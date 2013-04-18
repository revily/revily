$(document).on 'change', "#rules select", ->
  optgroup = $("#rules :selected").parent()
  label = $(optgroup).attr('label')
  $(this).closest('select').siblings('input[type=hidden]').val(label)
