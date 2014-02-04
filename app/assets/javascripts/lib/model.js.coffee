DS.Model.reopen
  errorMessages: (->
    messages = ""
    if @get("errors")?
      for field, errors of @get("errors")
        if errors
          for error in errors
            messages += "#{field} #{error} "
    messages
  ).property("isValid", "errors", "data")

  errorMessagesFull: (->
    messages = Em.A()
    if @get("errors")?
      for field, errors of @get("errors")
        if errors
          for error in errors
            messages.push "#{field} #{error}"
    messages
  ).property("isValid", "errors", "data")  
