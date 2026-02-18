module NamerKata
  require 'digest'

  module XYZ
    module Namer
      MAX_TITLE_LENGTH = 10
      RANDOM_HASH_LENGTH = 8

      def self.xyz_filename(target)
        filename = "#{target.publish_on.strftime("%d")}"
        filename << "#{target.xyz_category_prefix}"
        filename << "#{target.kind.delete("_")}"
        filename << "_#{age_segment(target)}" if target.personal?
        filename << "_#{target.id}"
        filename << "_#{random_hash}"
        filename << "_#{truncated_title(target)}"
        filename << ".jpg"
        filename
      end

      def self.age_segment(target)
        format("%03d", target.age || 0)
      end

      def self.random_hash
        Digest::SHA1.hexdigest(rand(10_000).to_s)[0, RANDOM_HASH_LENGTH]
      end

      def self.truncated_title(target)
        sanitized = target.title.gsub(/[^\[a-z\]]/i, '').downcase
        sanitized[0, MAX_TITLE_LENGTH]
      end
    end
  end
end
