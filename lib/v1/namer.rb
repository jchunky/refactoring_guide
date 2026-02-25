# frozen_string_literal: true

module NamerKata
  require "digest"

  module XYZ
    module Namer
      MAX_TITLE_LENGTH = 10

      def self.xyz_filename(target)
        [
          formatted_day(target),
          target.xyz_category_prefix,
          formatted_kind(target),
          formatted_age(target),
          "_#{target.id}",
          "_#{random_hash}",
          "_#{sanitized_title(target)}",
          ".jpg",
        ].compact.join
      end

      class << self
        private

        def formatted_day(target)
          target.publish_on.strftime("%d")
        end

        def formatted_kind(target)
          target.kind.delete("_")
        end

        def formatted_age(target)
          return unless target.personal?

          format("_%03d", target.age || 0)
        end

        def random_hash
          Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
        end

        def sanitized_title(target)
          cleaned = target.title.gsub(/[^\[a-z\]]/i, "").downcase
          cleaned[0, MAX_TITLE_LENGTH]
        end
      end
    end
  end
end
