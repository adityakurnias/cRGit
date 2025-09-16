# lib/crgit/tree.rb

require 'digest'
module CRGit
  class Tree
    def self.build_from_index(index_entries)
      # index_entries: array of [sha, path]
      tree = {}
      index_entries.each do |sha, path|
        segments = path.split('/')
        node = tree
        segments.each_with_index do |seg, i|
          if i == segments.length - 1
            node[seg] = sha
          else
            node[seg] ||= {}
            node = node[seg]
          end
        end
      end

      build_tree_object('root', tree)
    end

    def self.build_tree_object(name, tree_hash)
      require 'digest'
      content = +''
      tree_hash.each do |k, v|
        if v.is_a?(Hash)
          child_sha = build_tree_object(k, v)
          content << "tree #{child_sha} #{k}\n"
        else
          content << "blob #{v} #{k}\n"
        end
      end
      sha = Digest::SHA1.hexdigest(Time.now.iso8601 + name)
      CRGit::Object.new(sha).write_raw(Zlib::Deflate.deflate(content))
      sha
    end
  end
end
