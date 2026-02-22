module SupermarketKata
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

  module ProductUnit
    EACH = Object.new
    KILO = Object.new
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
            total = offer.argument * (quantity_as_int / x) + quantity_as_int % 2 * unit_price
            discount_n = unit_price * quantity - total
            discount = Discount.new(
              p,
              "2 for " + offer.argument.to_s,
              discount_n
            )
          end

        end
        x = 5 if offer.offer_type == SpecialOfferType::FIVE_FOR_AMOUNT
        number_of_x = quantity_as_int / x
        if offer.offer_type == SpecialOfferType::THREE_FOR_TWO && quantity_as_int > 2
          discount_amount = quantity * unit_price - ((number_of_x * 2 * unit_price) + quantity_as_int % 3 * unit_price)
          discount = Discount.new(p, "3 for 2", discount_amount)
        end
        if offer.offer_type == SpecialOfferType::TEN_PERCENT_DISCOUNT
          discount = Discount.new(
            p,
            offer.argument.to_s + "% off",
            quantity * unit_price * offer.argument / 100.0
          )
        end
        if offer.offer_type == SpecialOfferType::FIVE_FOR_AMOUNT && quantity_as_int >= 5
          discount_total = unit_price * quantity - (offer.argument * number_of_x + quantity_as_int % 5 * unit_price)
          discount = Discount.new(
            p,
            x.to_s + " for " + offer.argument.to_s,
            discount_total
          )
        end

        receipt.add_discount(discount) if discount
      end
    end
  end

  module SpecialOfferType
    THREE_FOR_TWO = Object.new
    TEN_PERCENT_DISCOUNT = Object.new
    TWO_FOR_AMOUNT = Object.new
    FIVE_FOR_AMOUNT = Object.new
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
    def initialize(columns = 40)
      @columns = columns
    end

    def print_receipt(receipt)
      result = ""
      receipt.items.each do |item|
        price = "%.2f" % item.total_price
        quantity = self.class.present_quantity(item)
        name = item.product.name
        unit_price = "%.2f" % item.price

        whitespace_size = @columns - name.size - price.size
        line = name + self.class.whitespace(whitespace_size) + price + "\n"

        line += "  " + unit_price + " * " + quantity + "\n" if item.quantity != 1

        result.concat(line)
      end
      receipt.discounts.each do |discount|
        product_presentation = discount.product.name
        price_presentation = "%.2f" % discount.discount_amount
        description = discount.description
        result.concat(description)
        result.concat("(")
        result.concat(product_presentation)
        result.concat(")")
        result.concat(self.class.whitespace(@columns - 3 - product_presentation.size - description.size - price_presentation.size))
        result.concat("-")
        result.concat(price_presentation)
        result.concat("\n")
      end
      result.concat("\n")
      price_presentation = "%.2f" % receipt.total_price.to_f
      total = "Total: "
      whitespace = self.class.whitespace(@columns - total.size - price_presentation.size)
      result.concat(total, whitespace, price_presentation)
      result.to_s
    end

    def self.present_quantity(item)
      ProductUnit::EACH == item.product.unit ? "%x" % item.quantity.to_i : "%.3f" % item.quantity
    end

    def self.whitespace(whitespace_size)
      whitespace = ""
      whitespace_size.times do
        whitespace.concat(" ")
      end
      whitespace
    end
  end
end
