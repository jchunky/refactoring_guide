# frozen_string_literal: true

module SupermarketReceiptKata
  class Product < Struct.new(:name, :unit, :unit_price, :discount)
    def initialize(name, unit, unit_price, discount: nil) = super(name, unit, unit_price, discount)
  end

  class ReceiptItem < Struct.new(:product, :quantity)
    def total_price = (quantity * unit_price).round(2)
    def unit_price = product.unit_price
  end

  class Discount < Struct.new(:product, :description, :discount_amount)
    def self.build(product, quantity)
      return unless product.discount

      unit_price = product.unit_price
      total_price = quantity * unit_price

      case product.discount[:type]
      when :percent_discount
        percent = product.discount[:percent]
        discount_amount = total_price * percent / 100.0
        Discount.new(product, "#{percent}% off", discount_amount)
      when :x_for_y
        x = product.discount[:x]
        y = product.discount[:y]
        return nil unless quantity > y

        groups, remainder = quantity.divmod(x)
        discounted_price = ((groups * y) + remainder) * unit_price
        discount_amount = total_price - discounted_price
        Discount.new(product, "#{x} for #{y}", discount_amount)
      when :x_for_amount
        x = product.discount[:x]
        amount = product.discount[:amount]
        return nil unless quantity >= x

        groups, remainder = quantity.divmod(x)
        discounted_price = (groups * amount) + (remainder * unit_price)
        discount_amount = total_price - discounted_price
        Discount.new(product, "#{x} for #{amount}", discount_amount)
      else
        raise "Unexpected offer type: #{product.discount[:type]}"
      end
    end

    def initialize(product, description, discount_amount) = super(product, description, discount_amount.round(2))
  end

  class Receipt < Struct.new(:items)
    def initialize = super([])

    def add_receipt_item(product, quantity) = items << ReceiptItem.new(product, quantity)

    def to_s = PrintReceipt.new.run(self)
    def total_price = items.sum(&:total_price) - discounts.sum(&:discount_amount)

    def discounts
      items
        .group_by(&:product)
        .transform_values { |items| items.sum(&:quantity) }
        .map { |product, quantity| Discount.build(product, quantity) }
        .compact
    end
  end

  class PrintReceipt < Struct.new(:width)
    def initialize(width = 40) = super

    def run(receipt)
      [
        receipt.items.map(&method(:format_item)),
        receipt.discounts.map(&method(:format_discount)),
        "",
        format_total(receipt.total_price),
      ].flatten.compact.join("\n")
    end

    private

    def format_item(item)
      price = format_price(item.total_price)
      [
        format_columns(item.product.name, price),
        ("  #{format_price(item.unit_price)} * #{format_quantity(item)}" if item.quantity != 1),
      ]
    end

    def format_discount(discount)
      description = discount.description
      product_name = discount.product.name
      price = format_price(-1 * discount.discount_amount)
      label = "#{description}(#{product_name})"
      format_columns(label, price)
    end

    def format_total(total)
      price = format_price(total.to_f)
      label = "Total: "
      format_columns(label, price)
    end

    def format_quantity(item)
      case item.product.unit
      when :each
        format("%i", item.quantity.to_i)
      when :kilo
        format("%.3f", item.quantity)
      else
        raise "Unexpected unit: #{item.product.unit}"
      end
    end

    def format_columns(left, right) = format("%s%s", left, right.rjust(width - left.size))
    def format_price(price) = format("%.2f", price)
  end
end
