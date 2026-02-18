# frozen_string_literal: true

module TheatricalPlayersKata
  class Performance < Data.define(:play_name, :play_type, :seat_count)
    def self.build(plays, performance_data)
      play = plays[performance_data["playID"]]
      play_type = play["type"]
      play_name = play["name"]
      seat_count = performance_data["audience"]
      performance_class = Object.const_get(play_type.capitalize) rescue (raise "unknown type: #{play_type}")
      performance_class.new(play_name:, play_type:, seat_count:)
    end
  end

  class Comedy < Performance
    def credits = [seat_count - 30, 0].max + (seat_count / 5).floor

    def price
      result = 30000 + (300 * seat_count)
      result += 10000 + (500 * (seat_count - 20)) if seat_count > 20
      result
    end
  end

  class Tragedy < Performance
    def credits = [seat_count - 30, 0].max

    def price
      result = 40000
      result += 1000 * (seat_count - 30) if seat_count > 30
      result
    end
  end

  class Statement < Data.define(:invoice, :plays)
    def to_s
      [
        "Statement for #{customer}",
        performances.map { format_performance(it) },
        "Amount owed is #{usd(total_price)}",
        "You earned #{total_credits} credits",
      ].join("\n").concat("\n")
    end

    private

    def customer = invoice["customer"]
    def total_price = performances.sum(&:price)
    def total_credits = performances.sum(&:credits)
    def performances = invoice["performances"].map { Performance.build(plays, it) }

    def format_performance(p) = format(" %s: %s (%s seats)", p.play_name, usd(p.price), p.seat_count)
    def usd(amount) = format("$%.2f", amount / 100.0)
  end

  def statement(invoice, plays) = Statement.new(invoice, plays).to_s
end
