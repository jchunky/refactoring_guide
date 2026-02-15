require 'minitest/autorun'
require "minitest/reporters"
require_relative 'english_number'

Minitest::Reporters.use!

class ClockTest < Minitest::Test
  def test_english_number
    assert_equal "zero", english_number(  0)
    assert_equal "nine", english_number(  9)
    assert_equal "ten", english_number( 10)
    assert_equal "eleven", english_number( 11)
    assert_equal "seventeen", english_number( 17)
    assert_equal "thirty", english_number( 30)
    assert_equal "thirty-two", english_number( 32)
    assert_equal "eighty-eight", english_number( 88)
    assert_equal "ninety-nine", english_number( 99)
    assert_equal "one hundred", english_number(100)
    assert_equal "one hundred one", english_number(101)
    assert_equal "two hundred thirty-four", english_number(234)
    assert_equal "thirty-two hundred eleven", english_number(3211)
    assert_equal "ninety-nine hundred ninety-nine hundred ninety-nine", english_number(999999)
    assert_equal "one hundred hundred hundred hundred hundred hundred", english_number(1000000000000)
  end
end
