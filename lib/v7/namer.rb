module NamerKata
  require 'digest'

  module XYZ
    module Namer
      def self.xyz_filename(target)
        [
          target.publish_on.strftime("%d"),
          target.xyz_category_prefix,
          target.kind.delete("_"),
          (target.personal? ? "_%03d" % (target.age || 0) : nil),
          "_#{target.id}",
          "_#{random_hash}",
          "_#{truncated_title(target.title)}",
          ".jpg"
        ].compact.join
      end

      private

      def self.random_hash
        Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
      end

      def self.truncated_title(title)
        title.gsub(/[^\[a-z\]]/i, '').downcase[0, 10]
      end
    end
  end
end
