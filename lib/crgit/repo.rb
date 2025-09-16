# lib/crgit/repo.rb
require 'fileutils'
module CRGit
  class Repo
    attr_reader :root

    def initialize(root = Dir.pwd)
      @root = root
    end

    def init
      if Dir.exist?(CRGit::CRGIT_DIR)
        warn 'Existing RGit project'
        exit 1
      end

      Dir.mkdir(CRGit::CRGIT_DIR)
      Dir.mkdir(CRGit::OBJECTS_DIR)
      Dir.mkdir(File.join(CRGit::OBJECTS_DIR, 'info'))
      Dir.mkdir(File.join(CRGit::OBJECTS_DIR, 'pack'))
      Dir.mkdir(File.join(CRGit::CRGIT_DIR, 'refs'))
      Dir.mkdir(File.join(CRGit::CRGIT_DIR, 'refs', 'heads'))
      Dir.mkdir(File.join(CRGit::CRGIT_DIR, 'refs', 'tags'))

      File.write(File.join(CRGit::CRGIT_DIR, 'HEAD'), "ref: refs/heads/master\n")
      File.write(File.join(CRGit::CRGIT_DIR, 'refs', 'heads', 'master'), '')
      puts "CRGIT initialized in #{CRGit::CRGIT_DIR}"
    end

    def current_head_ref
      head = File.read(File.join(CRGit::CRGIT_DIR, 'HEAD')).strip
      head.split.last # e.g. refs/heads/master
    end

    def update_ref(commit_sha)
      ref = current_head_ref
      File.write(File.join(CRGit::CRGIT_DIR, ref), commit_sha)
    end

    def head_commit
      ref = current_head_ref
      sha = File.read(File.join(CRGit::CRGIT_DIR, ref)).strip
      sha.empty? ? nil : sha
    end
  end
end
