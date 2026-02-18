# Version Loader
# 
# This module loads the appropriate version of kata implementations based on
# the VERSION environment variable.
#
# Usage:
#   VERSION=v0 rake test    # Test original (v0) code
#   VERSION=v1 rake test    # Test v1 refactored code
#   VERSION=v2 rake test    # Test v2 refactored code
#
# Default: v0
#
# Directory Structure:
#   lib/v0/          - Original kata implementations
#   lib/v1/          - Version 1 refactored code + prompt.md
#   lib/v2/          - Version 2 refactored code + prompt.md
#   ...

module VersionLoader
  VERSION = ENV.fetch('VERSION', 'v0')

  def self.version
    VERSION
  end

  def self.require_kata(kata_name)
    require_relative "#{VERSION}/#{kata_name}"
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
