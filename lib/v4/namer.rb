require 'securerandom'

module XYZ
  module Namer
    def self.xyz_filename(target)
      [
        target.publish_on.strftime("%d"),
        target.xyz_category_prefix,
        target.kind.delete("_"),
        age_segment(target),
        "_#{target.id}",
        "_#{SecureRandom.hex(4)}",
        "_#{sanitized_title(target)}",
        ".jpg"
      ].join
    end

    def self.age_segment(target)
      target.personal? ? "_%03d" % (target.age || 0) : ""
    end

    def self.sanitized_title(target)
      target.title.gsub(/[^\[a-z\]]/i, '').downcase[0, 10]
    end

    private_class_method :age_segment, :sanitized_title
  end
end
