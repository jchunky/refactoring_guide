# frozen_string_literal: true

module TheatricalPlayersKata
  class Price < Data.define(:cents)
    def self.zero = new(0)
    def to_s = format("$%.2f", cents / 100.0)
    def +(other) = self.class.new(cents + other.cents)
  end

  class Performance < Data.define(:play_name, :seat_count)
    def self.build(play_type, play_name, seat_count)
      Object.const_get(play_type.capitalize).new(play_name, seat_count)
    rescue NameError
      raise "unknown type: #{play_type}"
    end
  end

  class Tragedy < Performance
    def price
      result = 40_000
      result += 1_000 * (seat_count - 30) if seat_count > 30
      Price.new(result)
    end

    def credits = (seat_count - 30).clamp(0..)
  end

  class Comedy < Performance
    def price
      result = 30_000 + (300 * seat_count)
      result += 10_000 + (500 * (seat_count - 20)) if seat_count > 20
      Price.new(result)
    end

    def credits
      result = (seat_count - 30).clamp(0..)
      result += (seat_count / 5).floor
      result
    end
  end

  class Statement < Data.define(:customer, :performances)
    def self.build(invoice, plays)
      performances =
        invoice["performances"].map do |perf|
          play = plays[perf["playID"]]
          Performance.build(play["type"], play["name"], perf["audience"])
        end
      new(invoice["customer"], performances)
    end

    def to_s
      [
        "Statement for #{customer}",
        performances.map(&method(:formatted_performance)),
        "Amount owed is #{total_price}",
        "You earned #{total_credits} credits",
      ].join("\n").concat("\n")
    end

    private

    def formatted_performance(p) = format(" %s: %s (%s seats)", p.play_name, p.price, p.seat_count)
    def total_price = performances.sum(Price.zero, &:price)
    def total_credits = performances.sum(&:credits)
  end

  def statement(invoice, plays) = Statement.build(invoice, plays).to_s
end
