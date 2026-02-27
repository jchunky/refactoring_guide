# frozen_string_literal: true

require "securerandom"

module NamerKata
  module XYZ
    class Namer < Data.define(:file)
      MAX_TITLE_LENGTH = 10

      def self.xyz_filename(file) = new(file).filename

      def filename = [prefix, age, file.id, noise, title].compact.join("_").concat(".jpg")

      private

      def prefix = [publication_day, category, kind].join
      def publication_day = file.publish_on.strftime("%d")
      def category = file.xyz_category_prefix
      def kind = file.kind.delete("_")
      def age = (format("%03d", file.age.to_i) if file.personal?)
      def noise = SecureRandom.hex(4)
      def title = sanitized_title[0, MAX_TITLE_LENGTH]
      def sanitized_title = file.title.downcase.gsub(/[^\[a-z\]]/, "")
    end
  end
end
