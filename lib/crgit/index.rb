# lib/crgit/index.rb

require 'fileutils'

module CRGit
  class Index
    INDEX_PATH = File.join(CRGIT_DIR, 'index').freeze

    def self.ensure_index
      Dir.mkdir(CRGit::CRGIT_DIR) unless Dir.exist?(CRGit::CRGIT_DIR)
      FileUtils.touch(INDEX_PATH) unless File.exist?(INDEX_PATH)
    end

    def self.add_entry(sha, path)
      ensure_index
      entries = File.readlines(INDEX_PATH).map(&:chomp)
      # Replace existing entry for same path
      entries.reject! { |l| l.split(' ', 2)[1] == path }
      entries << "#{sha} #{path}"
      File.open(INDEX_PATH, 'w') { |f| f.puts entries }
    end

    def self.entries
      return [] unless File.exist?(INDEX_PATH)

      File.readlines(INDEX_PATH).map { |l| l.chomp.split(' ', 2) } # [sha, path]
    end

    def self.clear
      File.truncate(INDEX_PATH, 0) if File.exist?(INDEX_PATH)
    end
  end
end
