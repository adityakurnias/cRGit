# lib/crgit/commit.rb

require 'digest'
module CRGit
  class Commit
    def self.create(tree_sha, author = 'user')
      message_path = File.join(CRGit::CRGIT_DIR, 'COMMIT_EDITMSG')
      template = "# Title\n\n# Body\n"
      File.write(message_path, template) unless File.exist?(message_path)
      system("#{ENV['VISUAL'] || ENV['EDITOR'] || 'vi'} #{message_path} >/dev/tty")
      message = File.read(message_path)

      content = +''
      content << "tree #{tree_sha}\n"
      content << "author #{author}\n\n"
      content << message
      sha = Digest::SHA1.hexdigest(content)
      CRGit::Object.new(sha).write_raw(Zlib::Deflate.deflate(content))
      sha
    end

    def self.read(sha)
      CRGit::Object.read(sha)
    end
  end
end
