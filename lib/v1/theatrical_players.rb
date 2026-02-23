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
      base = 30_000 + (300 * seat_count)
      base += 10_000 + (500 * (seat_count - 20)) if seat_count > 20
      base
    end

    def credits
      credits = [seat_count - 30, 0].max
      credits += (seat_count / 5).floor
      credits
    end
  end

  class Tragedy < Performance
    def amount
      base = 40_000
      base += 1_000 * (seat_count - 30) if seat_count > 30
      base
    end

    def credits
      [seat_count - 30, 0].max
    end
  end

  class Statement < Struct.new(:invoice, :plays)
    def statement
      result = "Statement for #{customer}\n"
      performances.each do |perf|
        result += " #{perf.play_name}: #{format_usd(perf.amount)} (#{perf.seat_count} seats)\n"
      end
      result += "Amount owed is #{format_usd(total_amount)}\n"
      result += "You earned #{total_credits} credits\n"
      result
    end

    private

    def customer = invoice["customer"]
    def total_amount = performances.sum(&:amount)
    def total_credits = performances.sum(&:credits)
    def performances = invoice["performances"].map { |perf| Performance.build(plays, perf) }
    def format_usd(amount_in_cents) = "$#{format("%.2f", amount_in_cents / 100.0)}"
  end

  def statement(invoice, plays)
    Statement.new(invoice, plays).statement
  end
end
