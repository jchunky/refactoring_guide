module TheatricalPlayersKata
  # Declarative pricing rules: type => { price:, credits: }
  PLAY_RULES = {
    "comedy" => {
      price: ->(seats) {
        result = 30000 + (300 * seats)
        result += 10000 + (500 * (seats - 20)) if seats > 20
        result
      },
      credits: ->(seats) { [seats - 30, 0].max + (seats / 5).floor },
    },
    "tragedy" => {
      price: ->(seats) {
        result = 40000
        result += 1000 * (seats - 30) if seats > 30
        result
      },
      credits: ->(seats) { [seats - 30, 0].max },
    },
  }.freeze

  Performance = Data.define(:play_name, :play_type, :seat_count) do
    def price
      rules = PLAY_RULES.fetch(play_type) { raise "unknown type: #{play_type}" }
      rules[:price].call(seat_count)
    end

    def credits
      rules = PLAY_RULES.fetch(play_type) { raise "unknown type: #{play_type}" }
      rules[:credits].call(seat_count)
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

    def performances
      invoice["performances"].map { |pd|
        play = plays[pd["playID"]]
        Performance.new(play_name: play["name"], play_type: play["type"], seat_count: pd["audience"])
      }
    end

    def format_performance(perf)
      format(" %s: %s (%s seats)", perf.play_name, usd(perf.price), perf.seat_count)
    end

    def usd(amount) = format("$%.2f", amount / 100.0)
  end

  def statement(invoice, plays) = Statement.new(invoice, plays).to_s
end
