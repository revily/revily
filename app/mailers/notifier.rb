# class Notifier < Devise::Mailer
#   default :from => Reveille::Application.config.postmark_signature

#   def reset_password_instructions(user)
#     @resource = user
#     mail(:to => @resource.email)

# end