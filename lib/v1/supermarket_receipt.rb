# frozen_string_literal: true

module SupermarketReceiptKata
  class Discount < Data.define(:product, :description, :discount_amount)
    def self.build(product, quantity)
      discount = product.discount
      return unless discount

      unit_price = product.unit_price
      result =
        case discount[:type]
        when :percent
          percent = discount[:percent]
          discount_amount = quantity * unit_price * percent / 100.0
          ["#{percent}% off", discount_amount]
        when :x_for_y
          x = discount[:x]
          y = discount[:y]
          return if quantity < x

          full_price = quantity * unit_price
          discounted = ((quantity / x * y) + (quantity % x)) * unit_price
          ["#{x} for #{y}", full_price - discounted]
        when :x_for_amount
          x = discount[:x]
          amount = discount[:amount]
          return if quantity < x

          full_price = quantity * unit_price
          discounted = (quantity / x * amount) + (quantity % x * unit_price)
          ["#{x} for #{amount}", full_price - discounted]
        else
          raise "Unexpected type: #{discount[:type]}"
        end

      description, amount = result
      Discount.new(product, description, amount)
    end

    def discount_amount = super.round(2)
  end

  class Product < Struct.new(:name, :unit, :unit_price, :discount)
    def initialize(name, unit, unit_price, discount: nil) = super(name, unit, unit_price, discount)
  end

  class ReceiptItem < Data.define(:product, :quantity)
    def total_price = (quantity * unit_price).round(2)
    def unit_price = product.unit_price

    def formatted_quantity
      case product.unit
      when :each then format("%i", quantity)
      when :kilo then format("%.3f", quantity)
      else raise "Unexpected unit: #{product.unit}"
      end
    end
  end

  class Receipt < Struct.new(:items)
    def initialize = super([])

    def add_receipt_item(product, quantity) = items << ReceiptItem.new(product, quantity)

    def to_s = PrintReceipt.new(receipt: self).run
    def total_price = items.sum(&:total_price) - discounts.sum(&:discount_amount)

    def discounts
      items
        .group_by(&:product)
        .filter_map do |product, receipt_items|
          quantity = receipt_items.sum(&:quantity)
          Discount.build(product, quantity)
        end
    end
  end

  class PrintReceipt < Data.define(:receipt, :width)
    def initialize(receipt:, width: 40) = super

    def run
      [
        receipt.items.map { |item| format_receipt_item(item) },
        receipt.discounts.map { |discount| format_discount(discount) },
        "\n",
        total_line,
      ].join
    end

    private

    def format_receipt_item(item)
      price = usd(item.total_price)
      name = item.product.name
      price_width = width - name.length - 1
      line = format("%s %s\n", name, price.rjust(price_width))
      line += "  #{usd(item.unit_price)} * #{item.formatted_quantity}\n" if item.quantity != 1
      line
    end

    def format_discount(discount)
      product_name = discount.product.name
      price = usd(-1 * discount.discount_amount)
      description = discount.description
      price_width = width - description.length - product_name.length - 3
      format("%s(%s) %s\n", description, product_name, price.rjust(price_width))
    end

    def total_line
      price_width = width - 7
      format("Total: %s", usd(receipt.total_price).rjust(price_width))
    end

    def usd(price) = format("%.2f", price)
  end
end
