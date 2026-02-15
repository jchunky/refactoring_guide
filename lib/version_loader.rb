# Version Loader
# 
# This module loads the appropriate version of kata implementations based on
# the VERSION environment variable.
#
# Usage:
#   VERSION=original rake test    # Test original (unrefactored) code
#   VERSION=v1 rake test          # Test v1 refactored code
#   VERSION=v2 rake test          # Test v2 refactored code
#
# Default: original

module VersionLoader
  VERSION = ENV.fetch('VERSION', 'original')

  def self.version
    VERSION
  end

  def self.require_kata(kata_name)
    require_relative "#{kata_name}_#{VERSION}"
  end

  # List of all katas
  KATAS = %w[
    bottles
    character_creator
    english_number
    gilded_rose
    medicine_clash
    namer
    parrot
    tennis
    theatrical_players
    trivia
    yatzy
  ].freeze
end
