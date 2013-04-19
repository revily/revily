$(".editable").editable
  ajaxOptions:
    error: (xhr, status, error) ->
      console.log xhr.responseText
      console.log $(this)
      # msg = ''
      # errors = $.parseJSON xhr.responseText
      # console.log errors
      # if xhr and xhr.responseText
      #   msg = xhr.responseText
      # else
      #   $.each errors, (k,v) ->
      #     msg += "#{k}: #{v}<br>" 
      # $(this).removeClass('alert-success').addClass('alert-error').html(msg).show();

# $.fn.editable.defaults.mode = 'popup'

$("tr.policy td.loop_limit .editable").editable
  display: (value, response) ->
    console.log value
    console.log response
    $(this).html(response)