module NamerKata
  require 'digest'

  module XYZ
    module Namer
      def self.xyz_filename(target)
        FilenameBuilder.new(target).build
      end

      class FilenameBuilder
        def initialize(target)
          @target = target
        end

        def build
          [date_prefix, category_prefix, kind_part, age_part, id_part, random_part, title_part, extension].join
        end

        private

        def date_prefix = @target.publish_on.strftime("%d")
        def category_prefix = @target.xyz_category_prefix
        def kind_part = @target.kind.gsub("_", "")
        def id_part = "_#{@target.id}"
        def random_part = "_#{random_hash}"
        def extension = ".jpg"

        def age_part
          return "" unless @target.personal?
          "_%03d" % (@target.age || 0)
        end

        def title_part
          "_#{truncated_title}"
        end

        def truncated_title
          clean_title[0..truncate_length]
        end

        def truncate_length
          [clean_title.length, 9].min
        end

        def clean_title
          @target.title.gsub(/[^\[a-z\]]/i, '').downcase
        end

        def random_hash
          Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
        end
      end
    end
  end
end
