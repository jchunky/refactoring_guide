module NamerKata
  require 'digest'

  module XYZ
    module Namer
      def self.xyz_filename(target)
        day = target.publish_on.strftime("%d")
        prefix = target.xyz_category_prefix
        kind = target.kind.delete("_")
        age_segment = target.personal? ? "_%03d" % (target.age || 0) : ""
        id = target.id
        hash = Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]
        title = target.title.gsub(/[^\[a-z\]]/i, '').downcase[0, 10]

        "#{day}#{prefix}#{kind}#{age_segment}_#{id}_#{hash}_#{title}.jpg"
      end
    end
  end
end
