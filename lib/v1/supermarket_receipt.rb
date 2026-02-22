# frozen_string_literal: true

module SupermarketReceiptKata
  class Discount < Data.define(:product, :description, :discount_amount)
    def self.build(p, quantity)
      discount = p.discount
      return unless discount

      unit_price = p.unit_price
      full_price = quantity * unit_price

      case discount[:type]
      when :x_for_y
        x = discount[:x]
        y = discount[:y]
        number_of_x = quantity / x
        return unless quantity >= x

        discounted_price = ((number_of_x * y * unit_price) + (quantity % x * unit_price))
        discount_amount = full_price - discounted_price
        Discount.new(p, "#{x} for #{y}", discount_amount)
      when :x_for_amount
        x = discount[:x]
        amount = discount[:amount]
        return unless quantity >= x

        discounted_price = (amount * (quantity / x)) + (quantity % x * unit_price)
        discount_amount = full_price - discounted_price
        Discount.new(p, "#{x} for #{amount}", discount_amount)
      when :percent_discount
        percent = discount[:percent]
        discount_amount = full_price * percent / 100.0
        Discount.new(p, "#{percent}% off", discount_amount)
      else
        raise "Unexpected offer type: #{discount[:type]}"
      end
    end
  end

  class Product < Struct.new(:name, :unit, :unit_price, :discount)
    def initialize(name, unit, unit_price, discount: nil) = super(name, unit, unit_price, discount)
  end

  class ReceiptItem < Data.define(:product, :quantity)
    def total_price = quantity * unit_price
    def unit_price = product.unit_price
  end

  class Receipt < Struct.new(:items)
    def initialize = super([])

    def add_receipt_item(product, quantity) = items << ReceiptItem.new(product, quantity)

    def to_s = PrintReceipt.new(self).run
    def total_price = items.sum(&:total_price) - discounts.sum(&:discount_amount)

    def discounts
      @discounts ||= items
        .group_by(&:product)
        .map { |product, receipt_items|
          quantity = receipt_items.sum(&:quantity)
          Discount.build(product, quantity)
        }
        .compact
    end
  end

  class PrintReceipt < Struct.new(:receipt, :width)
    def initialize(receipt, width = 40) = super

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
