# frozen_string_literal: true

module TheatricalPlayersKata
  class Performance < Struct.new(:play_name, :seat_count)
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
      result
    end

    def credits = (seat_count - 30).clamp(0..)
  end

  class Comedy < Performance
    def price
      result = 30_000 + (300 * seat_count)
      result += 10_000 + (500 * (seat_count - 20)) if seat_count > 20
      result
    end

    def credits
      result = (seat_count - 30).clamp(0..)
      result += (seat_count / 5).floor
      result
    end
  end

  class Statement < Struct.new(:customer, :performances)
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
        performances.map do |perf|
          format(" %s: %s (%s seats)", perf.play_name, usd(perf.price), perf.seat_count)
        end,
        "Amount owed is #{usd(total_price)}",
        "You earned #{total_credits} credits",
      ].join("\n").concat("\n")
    end

    private

    def total_price = performances.sum(&:price)
    def total_credits = performances.sum(&:credits)
    def usd(cents) = format("$%.2f", cents / 100.0)
  end

  def statement(invoice, plays) = Statement.build(invoice, plays).to_s
end
