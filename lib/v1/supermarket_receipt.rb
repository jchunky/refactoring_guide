# frozen_string_literal: true

module SupermarketReceiptKata
  class Discount < Data.define(:product, :description, :discount_amount)
  end

  class Offer < Data.define(:offer_type, :product, :argument)
  end

  class Product < Data.define(:name, :unit)
  end

  class ProductQuantity < Data.define(:product, :quantity)
  end

  class ReceiptItem < Data.define(:product, :quantity, :price, :total_price)
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

    def print
      PrintReceipt.new(self).run
    end
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
      product_quantities[product] =
        if @product_quantities.key?(product)
          product_quantities[product] + quantity
        else
          quantity
        end
    end

    def handle_offers(receipt, offers, catalog)
      @product_quantities
        .keys
        .map { |p| build_discount(offers, catalog, p) }
        .compact
        .each { |discount| receipt.add_discount(discount) }
    end

    private

    def build_discount(offers, catalog, p)
      quantity = @product_quantities[p]
      return unless offers.key?(p)

      offer = offers[p]
      unit_price = catalog.unit_price(p)
      quantity_as_int = quantity.to_i

      case offer.offer_type
      when :three_for_two
        x = 3
        number_of_x = quantity_as_int / x
        return unless quantity_as_int >= x

        discount_amount = (quantity * unit_price) - ((number_of_x * 2 * unit_price) + (quantity_as_int % 3 * unit_price))
        Discount.new(p, "3 for 2", discount_amount)
      when :two_for_amount
        x = 2
        return unless quantity_as_int >= x

        total = (offer.argument * (quantity_as_int / x)) + (quantity_as_int % 2 * unit_price)
        discount_n = (unit_price * quantity) - total
        Discount.new(p, "2 for #{offer.argument}", discount_n)
      when :five_for_amount
        x = 5
        number_of_x = quantity_as_int / x
        return unless quantity_as_int >= x

        discount_total = (unit_price * quantity) - ((offer.argument * number_of_x) + (quantity_as_int % 5 * unit_price))
        Discount.new(p, "#{x} for #{offer.argument}", discount_total)
      when :ten_percent_discount
        Discount.new(p, "#{offer.argument}% off", quantity * unit_price * offer.argument / 100.0)
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
      unit_price = usd(item.price)
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
