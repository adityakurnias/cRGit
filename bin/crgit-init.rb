#!/usr/bin/env ruby
# bin/crgit-init.rb

lib_path = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
require 'crgit'
include CRGit

Repo.new.init
