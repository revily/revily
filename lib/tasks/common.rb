require "highline/import"
require "awesome_print"

def cli
  @cli ||= HighLine.new
end

def info(message)
  say cli.color(message, :green)
end

def warn(message)
  say cli.color(message, :yellow)
end

def error(message)
  say cli.color(message, :red)
end

def success(message)
  say cli.color(message, :blue)
end