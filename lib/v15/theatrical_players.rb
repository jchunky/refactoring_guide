module TheatricalPlayersKata
  Performance = Data.define(:play_name, :play_type, :seat_count)

  module PriceFn
    def self.price(perf)
      case perf.play_type
      in "comedy"
        result = 30000 + (300 * perf.seat_count)
        result += 10000 + (500 * (perf.seat_count - 20)) if perf.seat_count > 20
        result
      in "tragedy"
        result = 40000
        result += 1000 * (perf.seat_count - 30) if perf.seat_count > 30
        result
      else
        raise "unknown type: #{perf.play_type}"
      end
    end

    def self.credits(perf)
      base = [perf.seat_count - 30, 0].max
      case perf.play_type
      in "comedy" then base + (perf.seat_count / 5).floor
      in "tragedy" then base
      else raise "unknown type: #{perf.play_type}"
      end
    end
  end

  module StatementFn
    def self.build_performance(plays, performance_data)
      play = plays[performance_data["playID"]]
      raise "unknown type: #{play['type']}" unless %w[comedy tragedy].include?(play["type"])
      Performance.new(
        play_name: play["name"],
        play_type: play["type"],
        seat_count: performance_data["audience"]
      )
    end

    def self.format_usd(amount) = format("$%.2f", amount / 100.0)

    def self.format_performance(perf)
      format(" %s: %s (%s seats)", perf.play_name, format_usd(PriceFn.price(perf)), perf.seat_count)
    end

    def self.render(invoice, plays)
      performances = invoice["performances"].map { build_performance(plays, it) }
      total_price = performances.sum { PriceFn.price(it) }
      total_credits = performances.sum { PriceFn.credits(it) }

      [
        "Statement for #{invoice['customer']}",
        performances.map { format_performance(it) },
        "Amount owed is #{format_usd(total_price)}",
        "You earned #{total_credits} credits",
      ].join("\n").concat("\n")
    end
  end

  def statement(invoice, plays) = StatementFn.render(invoice, plays)
end
