#!/usr/bin/env ruby
# bin/crgit-add

lib_path = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
require 'digest'
require 'zlib'
require 'fileutils'
require 'crgit/object'
require 'crgit/index'

include CRGit

unless Dir.exist?(CRGit::CRGIT_DIR)
  warn 'Not an RGit project'
  exit 1
end

path = ARGV.first
if path.nil?
  warn 'No path specified'
  exit 1
end

file_contents = File.binread(path)
sha = Digest::SHA1.hexdigest(file_contents)
blob = Zlib::Deflate.deflate(file_contents)

# store compressed blob
object_dir = File.join(CRGit::OBJECTS_DIR, sha[0..1])
FileUtils.mkdir_p(object_dir)
blob_path = File.join(object_dir, sha[2..-1])
File.open(blob_path, 'wb') { |f| f.write blob }

Index.add_entry(sha, path)
puts "Added #{path} => #{sha}"
