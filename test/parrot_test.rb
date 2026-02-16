require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/version_loader'
VersionLoader.require_kata('parrot')
include ParrotKata

Minitest::Reporters.use!

class ParrotTest < Minitest::Test
  def test_european_parrot_speed
    parrot = Parrot.new(:european_parrot, 0, 0, false)
    assert_equal 12.0, parrot.speed
  end

  def test_african_parrot_with_one_coconut
    parrot = Parrot.new(:african_parrot, 1, 0, false)
    assert_equal 3.0, parrot.speed
  end

  def test_african_parrot_with_two_coconuts
    parrot = Parrot.new(:african_parrot, 2, 0, false)
    assert_equal 0.0, parrot.speed
  end

  def test_african_parrot_with_no_coconuts
    parrot = Parrot.new(:african_parrot, 0, 0, false)
    assert_equal 12.0, parrot.speed
  end

  def test_nailed_norwegian_blue_parrot
    parrot = Parrot.new(:norwegian_blue_parrot, 0, 0, true)
    assert_equal 0.0, parrot.speed
  end

  def test_not_nailed_norwegian_blue_parrot
    parrot = Parrot.new(:norwegian_blue_parrot, 0, 1.5, false)
    assert_equal 18.0, parrot.speed
  end

  def test_not_nailed_norwegian_blue_parrot_with_high_voltage
    parrot = Parrot.new(:norwegian_blue_parrot, 0, 4, false)
    assert_equal 24.0, parrot.speed
  end
end
