# Refactored using 99 Bottles of OOP principles:
# - Extract class for FilenameBuilder concept
# - Small methods that do one thing
# - Names reflect roles
# - Removed cryptic comments, code is self-documenting

require 'digest'

module XYZ
  module Namer
    def self.xyz_filename(target)
      FilenameBuilder.new(target).build
    end
  end

  class FilenameBuilder
    TITLE_MAX_LENGTH = 10
    EXTENSION = ".jpg"

    def initialize(target)
      @target = target
    end

    def build
      [
        date_prefix,
        category_prefix,
        kind_segment,
        age_segment,
        id_segment,
        random_segment,
        title_segment
      ].compact.join + EXTENSION
    end

    private

    attr_reader :target

    def date_prefix
      target.publish_on.strftime("%d")
    end

    def category_prefix
      target.xyz_category_prefix
    end

    def kind_segment
      target.kind.gsub("_", "")
    end

    def age_segment
      return nil unless target.personal?
      "_%03d" % (target.age || 0)
    end

    def id_segment
      "_#{target.id}"
    end

    def random_segment
      "_#{random_hash}"
    end

    def random_hash
      Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
    end

    def title_segment
      "_#{sanitized_title}"
    end

    def sanitized_title
      clean_title = target.title.gsub(/[^\[a-z\]]/i, '').downcase
      truncate_length = [clean_title.length, TITLE_MAX_LENGTH].min
      clean_title[0, truncate_length]
    end
  end
end
