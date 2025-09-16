# lib/crgit.rb

module CRGit
  CRGIT_DIR = '.crgit'.freeze
  OBJECTS_DIR = File.join(CRGIT_DIR, 'objects').freeze
end

require 'crgit/commit'
require 'crgit/index'
require 'crgit/object'
require 'crgit/repo'
require 'crgit/tree'
