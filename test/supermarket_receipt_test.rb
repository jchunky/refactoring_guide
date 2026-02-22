require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/version_loader'
VersionLoader.require_kata('supermarket_receipt')
include SupermarketReceiptKata

class SupermarketTest < Minitest::Test
  class FakeCatalog < SupermarketCatalog
    def initialize
      @products = {}
    end

    def add_product(product)
      @products[product.name] = product
    end
  end

  def test_discounts
    catalog = FakeCatalog.new
    cart = ShoppingCart.new
    teller = Teller.new(catalog)

    toothbrush = Product.new("toothbrush", :each,  0.99, :three_for_two, nil)
    catalog.add_product(toothbrush)
    cart.add_item_quantity(toothbrush, 5)

    apples = Product.new("apples", :kilo,  1.99, :ten_percent_discount, 20)
    catalog.add_product(apples)
    cart.add_item_quantity(apples, 2.5)

    rice = Product.new("rice", :each,  2.49, :ten_percent_discount, 10)
    catalog.add_product(rice)
    cart.add_item_quantity(rice, 2)

    toothpaste = Product.new("toothpaste", :each,  1.79, :five_for_amount, 7.49)
    catalog.add_product(toothpaste)
    cart.add_item_quantity(toothpaste, 6)

    cherry_tomatoes = Product.new("cherry tomatoes", :each,  0.69, :two_for_amount, 0.99)
    catalog.add_product(cherry_tomatoes)
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
    catalog = FakeCatalog.new
    cart = ShoppingCart.new
    teller = Teller.new(catalog)

    toothbrush = Product.new("toothbrush", :each,  0.33, :ten_percent_discount, 20)
    catalog.add_product(toothbrush)
    cart.add_item_quantity(toothbrush, 1)

    toothpaste = Product.new("toothpaste", :each,  0.33, :ten_percent_discount, 20)
    catalog.add_product(toothpaste)
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
    catalog = FakeCatalog.new
    cart = ShoppingCart.new
    teller = Teller.new(catalog)

    apples = Product.new("apples", :kilo,  1.00)
    catalog.add_product(apples)
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
