module NamerKata
  # Refactored to fix Feature Envy:
  # - Target object should generate its own filename components
  # - Ask objects to do things, don't reach into them
  require 'digest'

  module XYZ
    module Namer
      # Parameter Object to encapsulate filename generation context
      class FilenameContext
        MAX_TITLE_LENGTH = 10

        def initialize(target)
          @target = target
        end

        def day_prefix
          @target.publish_on.strftime("%d")
        end

        def category_prefix
          @target.xyz_category_prefix
        end

        def kind_segment
          @target.kind.gsub("_", "")
        end

        def age_segment
          @target.personal? ? "_%03d" % (@target.age || 0) : ""
        end

        def id_segment
          "_#{@target.id}"
        end

        def random_segment
          "_#{Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]}"
        end

        def title_segment
          sanitized = @target.title.gsub(/[^\[a-z\]]/i, '').downcase
          truncate_length = [sanitized.length, MAX_TITLE_LENGTH].min
          "_#{sanitized[0, truncate_length]}"
        end

        def extension
          ".jpg"
        end
      end

      class FilenameBuilder
        def initialize(context)
          @context = context
        end

        def build
          [
            @context.day_prefix,
            @context.category_prefix,
            @context.kind_segment,
            @context.age_segment,
            @context.id_segment,
            @context.random_segment,
            @context.title_segment,
            @context.extension
          ].join
        end
      end

      def self.xyz_filename(target)
        context = FilenameContext.new(target)
        FilenameBuilder.new(context).build
      end
    end
  end
end
