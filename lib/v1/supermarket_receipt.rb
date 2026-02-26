# frozen_string_literal: true

module SupermarketReceiptKata
  class Product < Struct.new(:name, :unit)
  end

  class ReceiptItem < Struct.new(:product, :quantity, :price, :total_price)
  end

  class Discount < Struct.new(:product, :description, :discount_amount)
  end

  class Offer < Struct.new(:offer_type, :product, :argument)
  end

  class ProductQuantity < Struct.new(:product, :quantity)
  end

  class Receipt < Struct.new(:items, :discounts)
    def initialize = super([], [])

    def total_price
      items_total = items.sum(&:total_price)
      discounts_total = discounts.sum(&:discount_amount)
      items_total - discounts_total
    end

    def add_product(product, quantity, price, total_price)
      items << ReceiptItem.new(product, quantity, price, total_price)
    end

    def add_discount(discount)
      discounts << discount
    end
  end

  class ShoppingCart < Struct.new(:items, :product_quantities)
    def initialize = super([], {})

    def add_item(product)
      add_item_quantity(product, 1.0)
    end

    def add_item_quantity(product, quantity)
      items << ProductQuantity.new(product, quantity)
      product_quantities[product] = product_quantities.fetch(product, 0) + quantity
    end

    def handle_offers(receipt, offers, catalog)
      product_quantities.each do |product, quantity|
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
      when :ten_percent_discount
        discount_amount = quantity * unit_price * offer.argument / 100.0
        Discount.new(product, "#{offer.argument}% off", discount_amount)

      when :three_for_two
        return nil unless quantity_as_int > 2

        groups = quantity_as_int / 3
        remainder = quantity_as_int % 3
        discount_amount = (quantity * unit_price) - ((groups * 2 * unit_price) + (remainder * unit_price))
        Discount.new(product, "3 for 2", discount_amount)

      when :two_for_amount
        return nil unless quantity_as_int >= 2

        groups = quantity_as_int / 2
        remainder = quantity_as_int % 2
        total = (offer.argument * groups) + (remainder * unit_price)
        Discount.new(product, "2 for #{offer.argument}", (unit_price * quantity) - total)

      when :five_for_amount
        return nil unless quantity_as_int >= 5

        groups = quantity_as_int / 5
        remainder = quantity_as_int % 5
        discount_amount = (unit_price * quantity) - ((offer.argument * groups) + (remainder * unit_price))
        Discount.new(product, "5 for #{offer.argument}", discount_amount)
      else
        raise "Unexpected offer type: #{offer.offer_type}"
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

  class Teller < Struct.new(:catalog, :offers)
    def initialize(catalog) = super(catalog, {})

    def add_special_offer(offer_type, product, argument)
      offers[product] = Offer.new(offer_type, product, argument)
    end

    def checks_out_articles_from(cart)
      receipt = Receipt.new

      cart.items.each do |pq|
        unit_price = catalog.unit_price(pq.product)
        total = pq.quantity * unit_price
        receipt.add_product(pq.product, pq.quantity, unit_price, total)
      end

      cart.handle_offers(receipt, offers, catalog)
      receipt
    end
  end

  class ReceiptPrinter < Struct.new(:width)
    def initialize(width = 40) = super

    def print_receipt(receipt)
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
        ("  #{format_price(item.price)} * #{format_quantity(item)}" if item.quantity != 1),
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
