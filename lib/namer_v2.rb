require "digest"

module XYZ
  module Namer
    def self.xyz_filename(target)
      # File format:
      # [day of month zero-padded][three-letter prefix] \
      # _[kind]_[age_if_kind_personal]_[target.id] \
      # _[8 random chars]_[10 first chars of title].jpg
      filename = target.publish_on.strftime("%d").to_s
      filename << target.xyz_category_prefix.to_s
      filename << target.kind.delete("_").to_s
      filename << format("_%03d", target.age || 0) if target.personal?
      filename << "_#{target.id}"
      filename << "_#{Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]}"
      truncated_title = target.title.gsub(/[^\[a-z\]]/i, "").downcase
      truncate_to = [truncated_title.length, 9].min
      filename << "_#{truncated_title[0..(truncate_to)]}"
      filename << ".jpg"
      filename
    end
  end
end
