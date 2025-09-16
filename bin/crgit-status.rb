#!/usr/bin/env ruby
# bin/rgit-status

lib_path = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
require 'crgit'
include CRGit

unless Dir.exist?(CRGit::CRGIT_DIR)
  warn 'Not an RGit project'
  exit 1
end

puts 'Changes to be committed:'
Index.entries.each do |sha, path|
  puts "\tnew file:   #{path} (#{sha[0..6]})"
end

head = Repo.new.head_commit
puts "\nCurrent HEAD: #{head || '(none)'}"
