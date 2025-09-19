#!/usr/bin/env ruby
# bin/crgit

command, *args = ARGV

if command.nil?
  warn 'Usage: crgit <command> [<args>]'
  exit 1
end

path_to_command = File.expand_path("crgit-#{command}.rb", __dir__)
unless File.exist?(path_to_command)
  warn "No such command: #{command}"
  exit 1
end

exec path_to_command, *args

# https://thoughtbot.com/blog/rebuilding-git-in-ruby