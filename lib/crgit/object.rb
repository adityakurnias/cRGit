# lib/crgit/object.rb
require 'fileutils'
require 'zlib'

module CRGit
  class Object
    def initialize(sha)
      @sha = sha
    end

    def write_raw(data)
      dir = File.join(CRGit::OBJECTS_DIR, @sha[0..1])
      FileUtils.mkdir_p(dir)
      path = File.join(dir, @sha[2..-1])
      File.open(path, 'wb') { |f| f.write data }
    end

    def self.store_raw(data)
      require 'digest'
      sha = Digest::SHA1.hexdigest(data)
      new(sha).write_raw(Zlib::Deflate.deflate(data))
      sha
    end

    def self.read(sha)
      path = File.join(CRGit::OBJECTS_DIR, sha[0..1], sha[2..-1])
      raw = File.binread(path)
      Zlib::Inflate.inflate(raw)
    end
  end
end
