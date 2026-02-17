module TheatricalPlayersKata
  Performance = Data.define(:play_name, :play_type, :seat_count)

  module PerformanceFn
    def self.build(plays, performance_data)
      play = plays[performance_data["playID"]]
      Performance.new(
        play_name: play["name"],
        play_type: play["type"],
        seat_count: performance_data["audience"]
      )
    end

    def self.price(perf)
      case perf
      in Performance[play_type: "comedy", seat_count: (..20)]
        30000 + (300 * perf.seat_count)
      in Performance[play_type: "comedy", seat_count: (21..)]
        30000 + (300 * perf.seat_count) + 10000 + (500 * (perf.seat_count - 20))
      in Performance[play_type: "tragedy", seat_count: (..30)]
        40000
      in Performance[play_type: "tragedy", seat_count: (31..)]
        40000 + 1000 * (perf.seat_count - 30)
      else
        raise "unknown type: #{perf.play_type}"
      end
    end

    def self.credits(perf)
      base = [perf.seat_count - 30, 0].max
      case perf
      in Performance[play_type: "comedy"] then base + (perf.seat_count / 5).floor
      in Performance[play_type: "tragedy"] then base
      else raise "unknown type: #{perf.play_type}"
      end
    end

    def self.format_usd(amount) = format("$%.2f", amount / 100.0)

    def self.format_line(perf)
      format(" %s: %s (%s seats)", perf.play_name, format_usd(price(perf)), perf.seat_count)
    end
  end

  module StatementFn
    def self.render(invoice, plays)
      performances = invoice["performances"].map { PerformanceFn.build(plays, it) }
      # Validate all types upfront
      performances.each { PerformanceFn.price(it) }

      total_price = performances.sum { PerformanceFn.price(it) }
      total_credits = performances.sum { PerformanceFn.credits(it) }

      [
        "Statement for #{invoice['customer']}",
        performances.map { PerformanceFn.format_line(it) },
        "Amount owed is #{PerformanceFn.format_usd(total_price)}",
        "You earned #{total_credits} credits",
      ].join("\n").concat("\n")
    end
  end

  def statement(invoice, plays) = StatementFn.render(invoice, plays)
end
