require 'digest'

module XYZ
  module Namer
    MAX_TITLE_LENGTH = 10
    FILE_EXTENSION = ".jpg"

    def self.xyz_filename(target)
      [
        formatted_day(target),
        target.xyz_category_prefix,
        formatted_kind(target),
        age_segment(target),
        "_#{target.id}",
        "_#{random_hash}",
        "_#{truncated_title(target)}",
        FILE_EXTENSION
      ].join
    end

    private

    def self.formatted_day(target)
      target.publish_on.strftime("%d")
    end

    def self.formatted_kind(target)
      target.kind.gsub("_", "")
    end

    def self.age_segment(target)
      return "" unless target.personal?
      "_%03d" % (target.age || 0)
    end

    def self.random_hash
      Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
    end

    def self.truncated_title(target)
      sanitized = sanitize_title(target.title)
      truncate_length = [sanitized.length, MAX_TITLE_LENGTH].min
      sanitized[0, truncate_length]
    end

    def self.sanitize_title(title)
      title.gsub(/[^\[a-z\]]/i, '').downcase
    end
  end
end
