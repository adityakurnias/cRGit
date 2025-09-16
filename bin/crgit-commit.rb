#!/usr/bin/env ruby
# bin/crgit-commit
#
lib_path = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
require 'digest'
require 'time'
require 'crgit/object'
require 'crgit/index'
require 'crgit/tree'
require 'crgit/commit'
require 'crgit/repo'

include CRGit

repo = Repo.new

entries = Index.entries
if entries.empty?
  warn 'Nothing to commit'
  exit 1
end

root_sha = Tree.build_from_index(entries)
commit_sha = Commit.create(root_sha, ENV['USER'] || 'user')
repo.update_ref(commit_sha)
Index.clear
puts "Committed #{commit_sha}"
