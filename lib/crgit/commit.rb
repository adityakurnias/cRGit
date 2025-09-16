# lib/crgit/commit.rb

require 'digest'
module CRGit
  class Commit
    def self.create(tree_sha, author = 'user')
      message_path = "#{CRGit::RGIT_DIR}/COMMIT_EDITMSG"
      template = "# Title\n\n# Body\n"
      File.write(message_path, template) unless File.exist?(message_path)
      system("#{ENV['VISUAL'] || ENV['EDITOR'] || 'vi'} #{message_path} >/dev/tty")
      message = File.read(message_path)

      sha = Digest::SHA1.hexdigest(Time.now.iso8601 + author)
      content = +''
      content << "tree #{tree_sha}\n"
      content << "author #{author}\n\n"
      content << message
      CRGit::Object.new(sha).write_raw(Zlib::Deflate.deflate(content))
      sha
    end

    def self.read(sha)
      CRGit::Object.read(sha)
    end
  end
end
