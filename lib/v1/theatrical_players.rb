# frozen_string_literal: true

module TheatricalPlayersKata
  class Performance < Struct.new(:play_name, :play_type, :seat_count)
    def self.build(plays, perf)
      play = plays[perf["playID"]]
      play_name = play["name"]
      play_type = play["type"]
      seat_count = perf["audience"]
      performance_class = Object.const_get(play_type.capitalize) rescue (raise "unknown type: #{play_type}")
      performance_class.new(play_name:, play_type:, seat_count:)
    end
  end

  class Comedy < Performance
    def amount
      result = 30_000 + (300 * seat_count)
      result += 10_000 + (500 * (seat_count - 20)) if seat_count > 20
      result
    end

    def credits = (seat_count - 30).clamp(0..) + (seat_count / 5).floor
  end

  class Tragedy < Performance
    def amount
      result = 40_000
      result += 1_000 * (seat_count - 30) if seat_count > 30
      result
    end

    def credits = (seat_count - 30).clamp(0..)
  end

  class Statement < Struct.new(:invoice, :plays)
    def statement
      [
        "Statement for #{customer}",
        performances.map(&method(:format_performance)),
        "Amount owed is #{usd(total_amount)}",
        "You earned #{total_credits} credits",
      ].join("\n").concat("\n")
    end

    private

    def format_performance(p) = " #{p.play_name}: #{usd(p.amount)} (#{p.seat_count} seats)"
    def customer = invoice["customer"]
    def total_amount = performances.sum(&:amount)
    def total_credits = performances.sum(&:credits)
    def performances = invoice["performances"].map { |perf| Performance.build(plays, perf) }
    def usd(amount_in_cents) = "$#{format("%.2f", amount_in_cents / 100.0)}"
  end

  def statement(invoice, plays)
    Statement.new(invoice, plays).statement
  end
end
