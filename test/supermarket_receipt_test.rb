require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/version_loader'
VersionLoader.require_kata('supermarket_receipt')
include SupermarketReceiptKata

class SupermarketTest < Minitest::Test
  def test_discounts
    receipt = Receipt.new

    toothbrush = Product.new("toothbrush", :each, 0.99, discount: { type: :x_for_y, x: 3, y: 2})
    receipt.add_receipt_item(toothbrush, 5)

    apples = Product.new("apples", :kilo, 1.99, discount: { type: :percent_discount, percent: 20})
    receipt.add_receipt_item(apples, 2.5)

    rice = Product.new("rice", :each, 2.49, discount: { type: :percent_discount, percent: 10})
    receipt.add_receipt_item(rice, 2)

    toothpaste = Product.new("toothpaste", :each, 1.79, discount: { type: :x_for_amount, x: 5, amount: 7.49})
    receipt.add_receipt_item(toothpaste, 6)

    cherry_tomatoes = Product.new("cherry tomatoes", :each, 0.69, discount: { type: :x_for_amount, x: 2, amount: 0.99})
    receipt.add_receipt_item(cherry_tomatoes, 5)

    output = receipt.to_s

    assert_equal <<~EXPECTED_OUTPUT.strip, output
      toothbrush                          4.95
        0.99 * 5
      apples                              4.98
        1.99 * 2.500
      rice                                4.98
        2.49 * 2
      toothpaste                         10.74
        1.79 * 6
      cherry tomatoes                     3.45
        0.69 * 5
      3 for 2(toothbrush)                -0.99
      20% off(apples)                    -1.00
      10% off(rice)                      -0.50
      5 for 7.49(toothpaste)             -1.46
      2 for 0.99(cherry tomatoes)        -0.78

      Total:                             24.37
    EXPECTED_OUTPUT
  end

  def test_total_is_sum_of_line_items
    receipt = Receipt.new

    toothbrush = Product.new("toothbrush", :each, 0.33, discount: {type: :percent_discount, percent: 20})
    receipt.add_receipt_item(toothbrush, 1)

    toothpaste = Product.new("toothpaste", :each, 0.33, discount: {type: :percent_discount, percent: 20 })
    receipt.add_receipt_item(toothpaste, 1)

    output = receipt.to_s

    assert_equal <<~EXPECTED_OUTPUT.strip, output
      toothbrush                          0.33
      toothpaste                          0.33
      20% off(toothbrush)                -0.07
      20% off(toothpaste)                -0.07

      Total:                              0.52
    EXPECTED_OUTPUT

    # NOTE: Total should be 0.52
  end

  def test_no_floating_point_rounding_errors
    receipt = Receipt.new

    apples = Product.new("apples", :kilo, 1.00)
    receipt.add_receipt_item(apples, 1.005)

    output = receipt.to_s

    assert_equal <<~EXPECTED_OUTPUT.strip, output
      apples                              1.01
        1.00 * 1.005

      Total:                              1.01
    EXPECTED_OUTPUT

    # NOTE: Total should be 1.01
  end
end
