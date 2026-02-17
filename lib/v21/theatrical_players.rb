module TheatricalPlayersKata
  # Protocol: every performance type must implement #price and #credits
  module PerformanceProtocol
    def price = raise NotImplementedError
    def credits = raise NotImplementedError
  end

  class ComedyPerformance
    include PerformanceProtocol
    attr_reader :play_name, :seat_count

    def initialize(play_name:, seat_count:)
      @play_name = play_name
      @seat_count = seat_count
    end

    def price
      result = 30000 + (300 * seat_count)
      result += 10000 + (500 * (seat_count - 20)) if seat_count > 20
      result
    end

    def credits = [seat_count - 30, 0].max + (seat_count / 5).floor
  end

  class TragedyPerformance
    include PerformanceProtocol
    attr_reader :play_name, :seat_count

    def initialize(play_name:, seat_count:)
      @play_name = play_name
      @seat_count = seat_count
    end

    def price
      result = 40000
      result += 1000 * (seat_count - 30) if seat_count > 30
      result
    end

    def credits = [seat_count - 30, 0].max
  end

  PERFORMANCE_TYPES = {
    "comedy" => ComedyPerformance,
    "tragedy" => TragedyPerformance,
  }.freeze

  module PerformanceFactory
    def self.build(plays, performance_data)
      play = plays[performance_data["playID"]]
      klass = PERFORMANCE_TYPES.fetch(play["type"]) { raise "unknown type: #{play['type']}" }
      klass.new(play_name: play["name"], seat_count: performance_data["audience"])
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
    def performances = invoice["performances"].map { PerformanceFactory.build(plays, it) }

    def format_performance(perf)
      format(" %s: %s (%s seats)", perf.play_name, usd(perf.price), perf.seat_count)
    end

    def usd(amount) = format("$%.2f", amount / 100.0)
  end

  def statement(invoice, plays) = Statement.new(invoice, plays).to_s
end
