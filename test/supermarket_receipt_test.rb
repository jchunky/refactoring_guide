require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/version_loader'
VersionLoader.require_kata('supermarket_receipt')
include SupermarketReceiptKata

class SupermarketTest < Minitest::Test
  def test_discounts
    cart = ShoppingCart.new
    teller = Teller.new

    toothbrush = Product.new(name: "toothbrush", unit: :each, unit_price: 0.99, discount: { type: :x_for_y, x: 3, y: 2})
    cart.add_item_quantity(toothbrush, 5)

    apples = Product.new(name: "apples", unit: :kilo, unit_price: 1.99, discount: { type: :percent_discount, percent: 20 })
    cart.add_item_quantity(apples, 2.5)

    rice = Product.new(name: "rice", unit: :each, unit_price: 2.49, discount: { type: :percent_discount, percent: 10 })
    cart.add_item_quantity(rice, 2)

    toothpaste = Product.new(name: "toothpaste", unit: :each, unit_price: 1.79, discount: { type: :x_for_amount, x: 5, amount: 7.49 })
    cart.add_item_quantity(toothpaste, 6)

    cherry_tomatoes = Product.new(name: "cherry tomatoes", unit: :each, unit_price: 0.69, discount: { type: :x_for_amount, x: 2, amount: 0.99 })
    cart.add_item_quantity(cherry_tomatoes, 5)

    receipt = teller.checks_out_articles_from(cart)

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
    cart = ShoppingCart.new
    teller = Teller.new

    toothbrush = Product.new(name: "toothbrush", unit: :each, unit_price: 0.33, discount: { type: :percent_discount, percent: 20 })
    cart.add_item_quantity(toothbrush, 1)

    toothpaste = Product.new(name: "toothpaste", unit: :each, unit_price: 0.33, discount: { type: :percent_discount, percent: 20 })
    cart.add_item_quantity(toothpaste, 1)

    receipt = teller.checks_out_articles_from(cart)

    output = receipt.to_s

    assert_equal <<~EXPECTED_OUTPUT.strip, output
      toothbrush                          0.33
      toothpaste                          0.33
      20% off(toothbrush)                -0.07
      20% off(toothpaste)                -0.07

      Total:                              0.53
    EXPECTED_OUTPUT

    # NOTE: Total should be 0.52
  end

  def test_no_floating_point_rounding_errors
    cart = ShoppingCart.new
    teller = Teller.new

    apples = Product.new(name: "apples", unit: :kilo, unit_price: 1.00)
    cart.add_item_quantity(apples, 1.005)

    receipt = teller.checks_out_articles_from(cart)

    output = receipt.to_s

    assert_equal <<~EXPECTED_OUTPUT.strip, output
      apples                              1.00
        1.00 * 1.005

      Total:                              1.00
    EXPECTED_OUTPUT

    # NOTE: Total should be 1.01
  end
end
