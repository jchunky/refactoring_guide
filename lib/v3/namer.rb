module NamerKata
  require 'digest'
  require 'securerandom'

  module XYZ
    module Namer
      def self.xyz_filename(target)
        [
          day_prefix(target),
          target.xyz_category_prefix,
          kind_segment(target),
          age_segment(target),
          "_#{target.id}",
          "_#{random_hex}",
          "_#{truncated_title(target)}",
          ".jpg"
        ].join
      end

      class << self
        private

        def day_prefix(target) = target.publish_on.strftime("%d")

        def kind_segment(target) = target.kind.delete("_")

        def age_segment(target) = target.personal? ? "_%03d" % (target.age || 0) : ""

        def random_hex = SecureRandom.hex(4)[0, 8]

        def truncated_title(target)
          clean_title = target.title.gsub(/[^\[a-z\]]/i, '').downcase
          clean_title[0, [clean_title.length, 10].min]
        end
      end
    end
  end
end
