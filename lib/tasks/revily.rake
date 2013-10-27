require "highline"
require "securerandom"
require "awesome_print"

Signal.trap("INT") { exit 1 }

namespace :revily do

  desc "Setup Revily database and run migrations"
  task :setup do
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
  end

  desc "Bootstrap the Revily application"
  task :bootstrap => [ :create_account, :create_application ] do
    success "Bootstrapping your Revily application...done!"
    success "Use the Revily web UI or the CLI to setup your service."
  end

  desc "Create an initial account and user"
  task :create_account => :pause_events do
    account_name = cli.ask "--> Enter an account name (company, team, etc.) " do |q|
      q.default = "Acme, Inc."
    end
    user_name = cli.ask "--> Enter your name " do |q|
      q.default = "Bill Williamson"
    end
    email = cli.ask "--> Enter your email address " do |q|
      q.default = "bill.williamson@example.com"
    end
    password = cli.ask("--> Enter your password ") { |q| q.echo = false }
    password_confirmation = cli.ask("--> Confirm your password ") { |q| q.echo = false }

    begin
      info "Creating your account..."
      account = Account.where(name: account_name).first_or_create!
      ActsAsTenant.current_tenant = account

      info "Creating your user..."
      user = account.users.where(
        name: user_name,
        email: email
      ).first_or_create!(
        password: password, 
        password_confirmation: password_confirmation
      )

      cli.say <<-CLI

Account:   #{account.name}
User:      #{user.name}
Email:     #{user.email}
API Token: #{user.authentication_token}

CLI
    rescue ActiveRecord::RecordInvalid => e
      error e.message
      exit 1
    end

    if ENV['DEBUG']
      ap account
      ap user
    end
  end

  desc "Create the initial OAuth application Revily Web will use"
  task :create_application => :pause_events do
    info "Creating the Revily Web OAuth application..."
    app = Doorkeeper::Application.create!(name: "Revily Web", redirect_uri: "urn:ietf:wg:oauth:2.0:oob")

    info "Add these environment variables to Revily Web"
    cli.say <<-CLI

REVILY_API_CLIENT_ID="#{app.uid}"
REVILY_API_CLIENT_SECRET="#{app.secret}"

CLI
  end

  task :pause_events => :environment do
    info "Pausing Revily's event system"
    Revily::Event.pause!
  end
end

def cli
  @cli ||= HighLine.new
end

def info(message)
  cli.say cli.color(message, :green)
end

def warn(message)
  cli.say cli.color(message, :yellow)
end

def error(message)
  cli.say cli.color(message, :red)
end

def success(message)
  cli.say cli.color(message, :blue)
end