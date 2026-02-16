module NamerKata
  require 'digest'

  module XYZ
    module Namer
      def self.xyz_filename(target)
        parts = [
          target.publish_on.strftime("%d"),
          target.xyz_category_prefix,
          target.kind.delete("_"),
          (target.personal? ? "_%03d" % (target.age || 0) : nil),
          "_#{target.id}",
          "_#{random_hash}",
          "_#{sanitize_title(target.title)}",
          ".jpg"
        ]
        parts.compact.join
      end

      private

      def self.random_hash
        Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
      end

      def self.sanitize_title(title)
        cleaned = title.gsub(/[^\[a-z\]]/i, '').downcase
        cleaned[0, [cleaned.length, 10].min]
      end
    end
  end
end
