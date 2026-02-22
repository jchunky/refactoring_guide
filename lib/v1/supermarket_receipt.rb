# frozen_string_literal: true

module SupermarketReceiptKata
  module ProductUnit
    EACH = Object.new
    KILO = Object.new
  end

  module SpecialOfferType
    THREE_FOR_TWO = Object.new
    TEN_PERCENT_DISCOUNT = Object.new
    TWO_FOR_AMOUNT = Object.new
    FIVE_FOR_AMOUNT = Object.new
  end

  class Discount
    attr_reader :product, :description, :discount_amount

    def initialize(product, description, discount_amount)
      @product = product
      @description = description
      @discount_amount = discount_amount
    end
  end

  class Offer
    attr_reader :product, :offer_type, :argument

    def initialize(offer_type, product, argument)
      @offer_type = offer_type
      @argument = argument
      @product = product
    end
  end

  Product = Struct.new(:name, :unit) do
    undef :name=, :unit=
  end

  class ProductQuantity
    attr_reader :product, :quantity

    def initialize(product, weight)
      @product = product
      @quantity = weight
    end
  end

  class Receipt
    def initialize
      @items = []
      @discounts = []
    end

    def total_price
      total = 0.0
      @items.each do |item|
        total += item.total_price
      end
      @discounts.each do |discount|
        total -= discount.discount_amount
      end
      total
    end

    def add_product(product, quantity, price, total_price)
      @items << ReceiptItem.new(product, quantity, price, total_price)
      nil
    end

    def items
      Array.new @items
    end

    def add_discount(discount)
      @discounts << discount
      nil
    end

    def discounts
      Array.new @discounts
    end
  end

  ReceiptItem = Struct.new(:product, :quantity, :price, :total_price) do
    undef :product=, :quantity=, :price=, :total_price=
  end

  class ShoppingCart
    attr_reader :product_quantities

    def initialize
      @items = []
      @product_quantities = {}
    end

    def items
      Array.new @items
    end

    def add_item(product)
      add_item_quantity(product, 1.0)
      nil
    end

    def add_item_quantity(product, quantity)
      @items << ProductQuantity.new(product, quantity)
      product_quantities[product] = if @product_quantities.key?(product)
                                      product_quantities[product] + quantity
                                    else
                                      quantity
                                    end
    end

    def handle_offers(receipt, offers, catalog)
      @product_quantities.each_key do |p|
        quantity = @product_quantities[p]
        next unless offers.key?(p)

        offer = offers[p]
        unit_price = catalog.unit_price(p)
        quantity_as_int = quantity.to_i
        discount = nil
        x = 1
        if offer.offer_type == SpecialOfferType::THREE_FOR_TWO
          x = 3

        elsif offer.offer_type == SpecialOfferType::TWO_FOR_AMOUNT
          x = 2
          if quantity_as_int >= 2
            total = (offer.argument * (quantity_as_int / x)) + (quantity_as_int % 2 * unit_price)
            discount_n = (unit_price * quantity) - total
            discount = Discount.new(
              p,
              "2 for #{offer.argument}",
              discount_n,
            )
          end

        end
        x = 5 if offer.offer_type == SpecialOfferType::FIVE_FOR_AMOUNT
        number_of_x = quantity_as_int / x
        if offer.offer_type == SpecialOfferType::THREE_FOR_TWO && quantity_as_int > 2
          discount_amount = (quantity * unit_price) - ((number_of_x * 2 * unit_price) + (quantity_as_int % 3 * unit_price))
          discount = Discount.new(p, "3 for 2", discount_amount)
        end
        if offer.offer_type == SpecialOfferType::TEN_PERCENT_DISCOUNT
          discount = Discount.new(
            p,
            "#{offer.argument}% off",
            quantity * unit_price * offer.argument / 100.0,
          )
        end
        if offer.offer_type == SpecialOfferType::FIVE_FOR_AMOUNT && quantity_as_int >= 5
          discount_total = (unit_price * quantity) - ((offer.argument * number_of_x) + (quantity_as_int % 5 * unit_price))
          discount = Discount.new(
            p,
            "#{x} for #{offer.argument}",
            discount_total,
          )
        end

        receipt.add_discount(discount) if discount
      end
    end
  end

  class SupermarketCatalog
    def add_product(product, price)
      raise NotImplementedError
    end

    def unit_price(product)
      raise NotImplementedError
    end
  end

  class Teller
    def initialize(catalog)
      @catalog = catalog
      @offers = {}
    end

    def add_special_offer(offer_type, product, argument)
      @offers[product] = Offer.new(offer_type, product, argument)
    end

    def checks_out_articles_from(the_cart)
      receipt = Receipt.new
      product_quantities = the_cart.items
      product_quantities.each do |pq|
        p = pq.product
        quantity = pq.quantity
        unit_price = @catalog.unit_price(p)
        price = quantity * unit_price
        receipt.add_product(p, quantity, unit_price, price)
      end
      the_cart.handle_offers(receipt, @offers, @catalog)

      receipt
    end
  end

  class ReceiptPrinter
    def initialize(columns = 40) = @columns = columns

    def print_receipt(receipt)
      [
        receipt.items.map(&method(:format_receipt_item)),
        receipt.discounts.map(&method(:format_discount)),
        "\n",
        total_line(receipt),
      ].join
    end

    private

    def format_receipt_item(item)
      price = usd(item.total_price)
      quantity = format_quantity(item)
      name = item.product.name
      unit_price = usd(item.price)
      price_width = @columns - name.length - 1
      line = format("%s %s\n", name, price.rjust(price_width))
      line += "  #{unit_price} * #{quantity}\n" if item.quantity != 1
      line
    end

    def format_discount(discount)
      product_presentation = discount.product.name
      price_presentation = usd(-1 * discount.discount_amount)
      description = discount.description
      price_width = @columns - description.length - product_presentation.length - 3
      format("%s(%s) %s\n", description, product_presentation, price_presentation.rjust(price_width))
    end

    def total_line(receipt)
      price_width = @columns - 7
      format("Total: %s", usd(receipt.total_price).rjust(price_width))
    end

    def format_quantity(item)
      unit = item.product.unit
      quantity = item.quantity
      case unit
      when ProductUnit::EACH then format("%i", quantity)
      when ProductUnit::KILO then format("%.3f", quantity)
      else raise "Unexpected unit: #{unit}"
      end
    end

    def usd(price) = format("%.2f", price)
    def whitespace(whitespace_size) = " " * whitespace_size
  end
end
