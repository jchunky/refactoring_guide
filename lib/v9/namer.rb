# Namer Kata - File Naming Convention Generator
#
# Generates standardized filenames for content items based on their attributes.
# This is typically used for content management systems that need consistent,
# unique, and descriptive filenames.
#
# Filename format:
#   [DD][prefix]_[kind]_[age]_[id]_[hash]_[title].jpg
#
# Components:
# - DD: Day of month (zero-padded)
# - prefix: Category-specific prefix (from target.xyz_category_prefix)
# - kind: Content type (underscores removed)
# - age: Only included for personal content (3-digit, zero-padded)
# - id: Unique identifier
# - hash: 8 random characters for uniqueness
# - title: First 10 characters of alphanumeric title (lowercase)

module NamerKata
  require 'digest'

  # XYZ is the legacy module name - kept for backward compatibility
  # This module handles content file naming conventions
  module XYZ
    module Namer
      # Maximum length for title portion of filename
      TITLE_MAX_LENGTH = 10

      # Length of random hash suffix for uniqueness
      HASH_LENGTH = 8

      # File extension for generated filenames
      FILE_EXTENSION = ".jpg"

      # Generates a standardized filename for a content target
      #
      # @param target [Object] Content item with the following attributes:
      #   - publish_on: Date when content is published
      #   - xyz_category_prefix: String prefix for the category
      #   - kind: String type of content (e.g., "personal_photo")
      #   - personal?: Boolean indicating if content is personal
      #   - age: Integer age value (only used if personal?)
      #   - id: Unique identifier for the content
      #   - title: Human-readable title
      #
      # @return [String] Formatted filename
      def self.xyz_filename(target)
        filename_parts = [
          day_of_month_component(target),
          category_prefix_component(target),
          kind_component(target),
          age_component(target),
          id_component(target),
          random_hash_component,
          sanitized_title_component(target)
        ]

        filename_parts.compact.join + FILE_EXTENSION
      end

      private

      # Day of month, zero-padded (e.g., "05" for the 5th)
      def self.day_of_month_component(target)
        target.publish_on.strftime("%d")
      end

      # Category-specific prefix
      def self.category_prefix_component(target)
        target.xyz_category_prefix
      end

      # Content kind with underscores removed
      def self.kind_component(target)
        target.kind.gsub("_", "")
      end

      # Age component for personal content (3-digit, zero-padded)
      # Returns nil for non-personal content
      def self.age_component(target)
        return nil unless target.personal?

        age_value = target.age || 0
        "_%03d" % age_value
      end

      # Unique identifier prefixed with underscore
      def self.id_component(target)
        "_#{target.id}"
      end

      # Random hash for filename uniqueness
      # Uses SHA1 hash of random number, truncated to HASH_LENGTH characters
      def self.random_hash_component
        random_seed = rand(10000).to_s
        hash_value = Digest::SHA1.hexdigest(random_seed)
        "_#{hash_value[0, HASH_LENGTH]}"
      end

      # Title sanitized for filename use:
      # - Only alphanumeric characters retained
      # - Converted to lowercase
      # - Truncated to TITLE_MAX_LENGTH characters
      def self.sanitized_title_component(target)
        sanitized_title = target.title.gsub(/[^\[a-z\]]/i, '').downcase
        truncate_length = [sanitized_title.length, TITLE_MAX_LENGTH].min
        "_#{sanitized_title[0, truncate_length]}"
      end
    end
  end
end
