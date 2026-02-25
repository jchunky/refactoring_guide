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

  Product = Struct.new(:name, :unit) do
    undef :name=, :unit=
  end

  ReceiptItem = Struct.new(:product, :quantity, :price, :total_price) do
    undef :product=, :quantity=, :price=, :total_price=
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

  class ProductQuantity
    attr_reader :product, :quantity

    def initialize(product, quantity)
      @product = product
      @quantity = quantity
    end
  end

  class Receipt
    def initialize
      @items = []
      @discounts = []
    end

    def total_price
      items_total = @items.sum(&:total_price)
      discounts_total = @discounts.sum(&:discount_amount)
      items_total - discounts_total
    end

    def add_product(product, quantity, price, total_price)
      @items << ReceiptItem.new(product, quantity, price, total_price)
    end

    def items
      @items.dup
    end

    def add_discount(discount)
      @discounts << discount
    end

    def discounts
      @discounts.dup
    end
  end

  class ShoppingCart
    attr_reader :product_quantities

    def initialize
      @items = []
      @product_quantities = {}
    end

    def items
      @items.dup
    end

    def add_item(product)
      add_item_quantity(product, 1.0)
    end

    def add_item_quantity(product, quantity)
      @items << ProductQuantity.new(product, quantity)
      @product_quantities[product] = @product_quantities.fetch(product, 0) + quantity
    end

    def handle_offers(receipt, offers, catalog)
      @product_quantities.each do |product, quantity|
        next unless offers.key?(product)

        offer = offers[product]
        unit_price = catalog.unit_price(product)
        discount = calculate_discount(offer, product, quantity, unit_price)
        receipt.add_discount(discount) if discount
      end
    end

    private

    def calculate_discount(offer, product, quantity, unit_price)
      quantity_as_int = quantity.to_i

      case offer.offer_type
      when SpecialOfferType::TEN_PERCENT_DISCOUNT
        discount_amount = quantity * unit_price * offer.argument / 100.0
        Discount.new(product, "#{offer.argument}% off", discount_amount)

      when SpecialOfferType::THREE_FOR_TWO
        return nil unless quantity_as_int > 2

        groups = quantity_as_int / 3
        remainder = quantity_as_int % 3
        discount_amount = (quantity * unit_price) - ((groups * 2 * unit_price) + (remainder * unit_price))
        Discount.new(product, "3 for 2", discount_amount)

      when SpecialOfferType::TWO_FOR_AMOUNT
        return nil unless quantity_as_int >= 2

        groups = quantity_as_int / 2
        remainder = quantity_as_int % 2
        total = (offer.argument * groups) + (remainder * unit_price)
        Discount.new(product, "2 for #{offer.argument}", (unit_price * quantity) - total)

      when SpecialOfferType::FIVE_FOR_AMOUNT
        return nil unless quantity_as_int >= 5

        groups = quantity_as_int / 5
        remainder = quantity_as_int % 5
        discount_amount = (unit_price * quantity) - ((offer.argument * groups) + (remainder * unit_price))
        Discount.new(product, "5 for #{offer.argument}", discount_amount)
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

    def checks_out_articles_from(cart)
      receipt = Receipt.new

      cart.items.each do |pq|
        unit_price = @catalog.unit_price(pq.product)
        total = pq.quantity * unit_price
        receipt.add_product(pq.product, pq.quantity, unit_price, total)
      end

      cart.handle_offers(receipt, @offers, @catalog)
      receipt
    end
  end

  class ReceiptPrinter
    def initialize(columns = 40)
      @columns = columns
    end

    def print_receipt(receipt)
      result = ""
      result += receipt.items.map { |item| format_item(item) }.join
      result += receipt.discounts.map { |discount| format_discount(discount) }.join
      result += "\n"
      result += format_total(receipt.total_price)
      result
    end

    private

    def format_item(item)
      price = "%.2f" % item.total_price
      line = "#{item.product.name}#{padding(item.product.name.size, price.size)}#{price}\n"
      line += "  #{"%.2f" % item.price} * #{format_quantity(item)}\n" if item.quantity != 1
      line
    end

    def format_discount(discount)
      description = discount.description
      product_name = discount.product.name
      price = "%.2f" % discount.discount_amount
      label = "#{description}(#{product_name})"
      "#{label}#{padding(label.size + 1, price.size)}-#{price}\n"
    end

    def format_total(total)
      price = format("%.2f", total.to_f)
      label = "Total: "
      "#{label}#{padding(label.size, price.size)}#{price}"
    end

    def format_quantity(item)
      if item.product.unit == ProductUnit::EACH
        format("%x", item.quantity.to_i)
      else
        "%.3f" % item.quantity
      end
    end

    def padding(left_size, right_size)
      " " * [@columns - left_size - right_size, 0].max
    end
  end
end
