module TheatricalPlayersKata
  module StatementPipeline
    def self.build_performance(plays, perf_data)
      play = plays[perf_data["playID"]]
      { play_name: play["name"], play_type: play["type"], seat_count: perf_data["audience"] }
    end

    def self.compute_price(perf)
      case perf[:play_type]
      when "comedy"
        result = 30000 + (300 * perf[:seat_count])
        result += 10000 + (500 * (perf[:seat_count] - 20)) if perf[:seat_count] > 20
        result
      when "tragedy"
        result = 40000
        result += 1000 * (perf[:seat_count] - 30) if perf[:seat_count] > 30
        result
      else
        raise "unknown type: #{perf[:play_type]}"
      end
    end

    def self.compute_credits(perf)
      base = [perf[:seat_count] - 30, 0].max
      case perf[:play_type]
      when "comedy" then base + (perf[:seat_count] / 5).floor
      when "tragedy" then base
      else raise "unknown type: #{perf[:play_type]}"
      end
    end

    def self.format_usd(amount) = format("$%.2f", amount / 100.0)

    def self.format_line(perf)
      format(" %s: %s (%s seats)", perf[:play_name], format_usd(compute_price(perf)), perf[:seat_count])
    end

    def self.render(invoice, plays)
      invoice["performances"]
        .map { build_performance(plays, it) }
        .then { |perfs|
          total_price = perfs.sum { compute_price(it) }
          total_credits = perfs.sum { compute_credits(it) }
          [
            "Statement for #{invoice['customer']}",
            perfs.map { format_line(it) },
            "Amount owed is #{format_usd(total_price)}",
            "You earned #{total_credits} credits",
          ].join("\n").concat("\n")
        }
    end
  end

  def statement(invoice, plays) = StatementPipeline.render(invoice, plays)
end
