module SupermarketReceiptKata
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
      @items.sum(&:total_price) - @discounts.sum(&:discount_amount)
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
      @product_quantities.each do |product, quantity|
        next unless offers.key?(product)

        offer = offers[product]
        unit_price = catalog.unit_price(product)
        discount = compute_discount(offer, product, quantity, unit_price)
        receipt.add_discount(discount) if discount
      end
    end

    private

    def compute_discount(offer, product, quantity, unit_price)
      quantity_as_int = quantity.to_i

      case offer.offer_type
      when SpecialOfferType::TEN_PERCENT_DISCOUNT
        amount = quantity * unit_price * offer.argument / 100.0
        Discount.new(product, "#{offer.argument}% off", amount)
      when SpecialOfferType::THREE_FOR_TWO
        bundle_discount(product, quantity, quantity_as_int, unit_price, 3, 2, "3 for 2")
      when SpecialOfferType::TWO_FOR_AMOUNT
        fixed_price_discount(product, quantity, quantity_as_int, unit_price, 2, offer.argument)
      when SpecialOfferType::FIVE_FOR_AMOUNT
        fixed_price_discount(product, quantity, quantity_as_int, unit_price, 5, offer.argument)
      end
    end

    def bundle_discount(product, quantity, quantity_as_int, unit_price, bundle_size, pay_for, description)
      return nil if quantity_as_int < bundle_size

      bundles = quantity_as_int / bundle_size
      remainder = quantity_as_int % bundle_size
      amount = quantity * unit_price - (bundles * pay_for * unit_price + remainder * unit_price)
      Discount.new(product, description, amount)
    end

    def fixed_price_discount(product, quantity, quantity_as_int, unit_price, bundle_size, bundle_price)
      return nil if quantity_as_int < bundle_size

      bundles = quantity_as_int / bundle_size
      remainder = quantity_as_int % bundle_size
      total = bundle_price * bundles + remainder * unit_price
      amount = unit_price * quantity - total
      Discount.new(product, "#{bundle_size} for #{bundle_price}", amount)
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
      the_cart.items.each do |pq|
        unit_price = @catalog.unit_price(pq.product)
        price = pq.quantity * unit_price
        receipt.add_product(pq.product, pq.quantity, unit_price, price)
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
        result += format_line_item(item)
      end
      receipt.discounts.each do |discount|
        result += format_discount(discount)
      end
      result += "\n"
      result += format_total(receipt)
      result
    end

    def self.present_quantity(item)
      ProductUnit::EACH == item.product.unit ? "%x" % item.quantity.to_i : "%.3f" % item.quantity
    end

    def self.whitespace(size)
      " " * size
    end

    private

    def format_line_item(item)
      price = "%.2f" % item.total_price
      name = item.product.name
      line = name + self.class.whitespace(@columns - name.size - price.size) + price + "\n"
      line += "  #{'%.2f' % item.price} * #{self.class.present_quantity(item)}\n" if item.quantity != 1
      line
    end

    def format_discount(discount)
      product_name = discount.product.name
      price = "%.2f" % discount.discount_amount
      description = discount.description
      padding = self.class.whitespace(@columns - 3 - product_name.size - description.size - price.size)
      "#{description}(#{product_name})#{padding}-#{price}\n"
    end

    def format_total(receipt)
      price = "%.2f" % receipt.total_price.to_f
      total = "Total: "
      whitespace = self.class.whitespace(@columns - total.size - price.size)
      total + whitespace + price
    end
  end
end
