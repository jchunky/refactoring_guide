module NamerKata
  require 'digest'

  module XYZ
    module Namer
      def self.xyz_filename(target)
        FilenameBuilder.new(target).build
      end
    end

    class FilenameBuilder
      MAX_TITLE_LENGTH = 10

      def initialize(target)
        @target = target
      end

      def build
        parts = [
          formatted_date,
          @target.xyz_category_prefix,
          formatted_kind,
          age_segment,
          "_#{@target.id}",
          "_#{random_hash}",
          "_#{sanitized_title}",
          ".jpg"
        ]
        parts.compact.join
      end

      private

      def formatted_date
        @target.publish_on.strftime("%d")
      end

      def formatted_kind
        @target.kind.delete("_")
      end

      def age_segment
        return nil unless @target.personal?
        "_%03d" % (@target.age || 0)
      end

      def random_hash
        Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
      end

      def sanitized_title
        cleaned = @target.title.gsub(/[^\[a-z\]]/i, '').downcase
        cleaned[0, [cleaned.length, MAX_TITLE_LENGTH].min]
      end
    end
  end
end
