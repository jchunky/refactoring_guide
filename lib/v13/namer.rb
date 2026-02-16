module NamerKata
  require 'digest'

  module XYZ
    module Namer
      def self.xyz_filename(target)
        date_prefix = target.publish_on.strftime("%d")
        category = target.xyz_category_prefix
        kind = target.kind.delete("_")
        age_segment = target.personal? ? "_%03d" % (target.age || 0) : ""
        id = target.id.to_s
        hash = Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
        title = target.title.gsub(/[^\[a-z\]]/i, "").downcase[0, 10]

        "#{date_prefix}#{category}#{kind}#{age_segment}_#{id}_#{hash}_#{title}.jpg"
      end
    end
  end
end
