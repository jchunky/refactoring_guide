module TheatricalPlayersKata
  Performance = Data.define(:play_name, :play_type, :seat_count)

  module PricingRules
    def self.price(perf)
      case perf.play_type
      when "comedy"
        result = 30000 + (300 * perf.seat_count)
        result += 10000 + (500 * (perf.seat_count - 20)) if perf.seat_count > 20
        result
      when "tragedy"
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
      when "comedy" then base + (perf.seat_count / 5).floor
      when "tragedy" then base
      else raise "unknown type: #{perf.play_type}"
      end
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
    def total_price = performances.sum { PricingRules.price(it) }
    def total_credits = performances.sum { PricingRules.credits(it) }

    def performances
      invoice["performances"].map { |pd|
        play = plays[pd["playID"]]
        Performance.new(play_name: play["name"], play_type: play["type"], seat_count: pd["audience"])
      }
    end

    def format_performance(perf)
      format(" %s: %s (%s seats)", perf.play_name, usd(PricingRules.price(perf)), perf.seat_count)
    end

    def usd(amount) = format("$%.2f", amount / 100.0)
  end

  def statement(invoice, plays) = Statement.new(invoice, plays).to_s
end
