# frozen_string_literal: true

module SupermarketReceiptKata
  class Discount < Data.define(:product, :description, :discount_amount)
    def self.build(product_quantities, p)
      quantity = product_quantities[p]
      return unless p.offer_type

      unit_price = p.unit_price
      quantity_as_int = quantity

      case p.offer_type
      when :three_for_two
        x = 3
        y = 2
        number_of_x = quantity_as_int / x
        return unless quantity_as_int >= x

        discount_amount = (quantity * unit_price) - ((number_of_x * y * unit_price) + (quantity_as_int % x * unit_price))
        Discount.new(p, "#{x} for #{y}", discount_amount)
      when :two_for_amount
        x = 2
        return unless quantity_as_int >= x

        total = (p.argument * (quantity_as_int / x)) + (quantity_as_int % 2 * unit_price)
        discount_amount = (unit_price * quantity) - total
        Discount.new(p, "#{x} for #{p.argument}", discount_amount)
      when :five_for_amount
        x = 5
        number_of_x = quantity_as_int / x
        return unless quantity_as_int >= x

        discount_total = (unit_price * quantity) - ((p.argument * number_of_x) + (quantity_as_int % 5 * unit_price))
        Discount.new(p, "#{x} for #{p.argument}", discount_total)
      when :ten_percent_discount
        discount_amount = quantity * unit_price * p.argument / 100.0
        Discount.new(p, "#{p.argument}% off", discount_amount)
      else
        raise "Unexpected offer type: #{p.offer_type}"
      end
    end
  end

  class Product < Struct.new(:name, :unit, :unit_price, :offer_type, :argument)
  end

  class ProductQuantity < Data.define(:product, :quantity)
  end

  class ReceiptItem < Data.define(:product, :quantity, :unit_price)
    def total_price = quantity * unit_price
  end

  class Receipt < Struct.new(:items, :discounts)
    def initialize = super([], [])

    def add_product(pq) = items << ReceiptItem.new(pq.product, pq.quantity, pq.product.unit_price)
    def add_discount(discount) = discounts << discount

    def to_s = PrintReceipt.new(self).run
    def total_price = items.sum(&:total_price) - discounts.sum(&:discount_amount)
  end

  class Teller
    def checks_out_articles_from(the_cart)
      receipt = Receipt.new
      the_cart.items.each do |pq|
        receipt.add_product(pq)
      end
      the_cart.handle_offers(receipt)

      receipt
    end
  end

  class ShoppingCart < Struct.new(:items, :product_quantities)
    def initialize = super([], {})

    def add_item_quantity(product, quantity)
      items << ProductQuantity.new(product, quantity)
      product_quantities[product] ||= 0
      product_quantities[product] += quantity
    end

    def handle_offers(receipt)
      product_quantities
        .keys
        .map { |p| Discount.build(product_quantities, p) }
        .compact
        .each { |discount| receipt.add_discount(discount) }
    end
  end

  class PrintReceipt
    attr_reader :receipt, :width

    def initialize(receipt, width = 40)
      @receipt = receipt
      @width = width
    end

    def run
      [
        receipt.items.map(&method(:format_receipt_item)),
        receipt.discounts.map(&method(:format_discount)),
        "\n",
        total_line,
      ].join
    end

    private

    def format_receipt_item(item)
      price = usd(item.total_price)
      quantity = format_quantity(item)
      name = item.product.name
      unit_price = usd(item.unit_price)
      price_width = width - name.length - 1
      line = format("%s %s\n", name, price.rjust(price_width))
      line += "  #{unit_price} * #{quantity}\n" if item.quantity != 1
      line
    end

    def format_discount(discount)
      product_presentation = discount.product.name
      price_presentation = usd(-1 * discount.discount_amount)
      description = discount.description
      price_width = width - description.length - product_presentation.length - 3
      format("%s(%s) %s\n", description, product_presentation, price_presentation.rjust(price_width))
    end

    def total_line
      price_width = width - 7
      format("Total: %s", usd(receipt.total_price).rjust(price_width))
    end

    def format_quantity(item)
      unit = item.product.unit
      quantity = item.quantity
      case unit
      when :each then format("%i", quantity)
      when :kilo then format("%.3f", quantity)
      else raise "Unexpected unit: #{unit}"
      end
    end

    def usd(price) = format("%.2f", price)
    def whitespace(whitespace_size) = " " * whitespace_size
  end
end
