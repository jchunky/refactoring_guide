require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
require 'ostruct'
require_relative '../lib/version_loader'
VersionLoader.require_kata('namer')
include NamerKata

Minitest::Reporters.use!

class NamerTest < Minitest::Test
  def setup
    @target = OpenStruct.new(
      publish_on: Date.new(2012, 2, 7),
      xyz_category_prefix: 'abc',
      kind: 'magic_unicorn',
      personal?: false,
      id: 1337,
      title: 'I <3 SPARKLY Sparkles!!1!'
    )
  end

  def test_works
    result = XYZ::Namer.xyz_filename(@target)
    assert_match(/07abcmagicunicorn_1337_[0-9a-f]{8}_isparklysp\.jpg/, result)
  end

  def test_leaves_square_brackets
    @target.title = 'i[sparkle]s'
    result = XYZ::Namer.xyz_filename(@target)
    assert_match(/07abcmagicunicorn_1337_[0-9a-f]{8}_i\[sparkle\]\.jpg/, result)
  end

  def test_personalizes
    @target[:personal?] = true
    @target.age = 42
    result = XYZ::Namer.xyz_filename(@target)
    assert_match(/07abcmagicunicorn_042_1337_[0-9a-f]{8}_isparklysp\.jpg/, result)
  end

  def test_handles_nil_age
    @target[:personal?] = true
    @target.age = nil
    result = XYZ::Namer.xyz_filename(@target)
    assert_match(/07abcmagicunicorn_000_1337_[0-9a-f]{8}_isparklysp\.jpg/, result)
  end

  def test_handles_short_titles
    @target.title = 'O HAI'
    result = XYZ::Namer.xyz_filename(@target)
    assert_match(/07abcmagicunicorn_1337_[0-9a-f]{8}_ohai\.jpg/, result)
  end
end
