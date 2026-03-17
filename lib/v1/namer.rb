module NamerKata
  require 'digest'

  module XYZ
    module Namer

      def self.xyz_filename(target)
        # File format:
        # [day of month zero-padded][three-letter prefix]
        # _[kind]_[age_if_kind_personal]_[target.id]
        # _[8 random chars]_[10 first chars of title].jpg
        random_hash = Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
        truncated_title = target.title.gsub(/[^\[a-z\]]/i, '').downcase[0, 10]
        age_part = target.personal? ? "_%03d" % (target.age || 0) : ""

        "#{target.publish_on.strftime('%d')}" \
        "#{target.xyz_category_prefix}" \
        "#{target.kind.gsub('_', '')}" \
        "#{age_part}" \
        "_#{target.id}" \
        "_#{random_hash}" \
        "_#{truncated_title}" \
        ".jpg"
      end

    end
  end
end
