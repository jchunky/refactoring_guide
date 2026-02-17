module TheatricalPlayersKata
  class Performance
    attr_reader :play_name, :play_type, :seat_count

    def initialize(play_name:, play_type:, seat_count:)
      @play_name = play_name
      @play_type = play_type
      @seat_count = seat_count
    end

    def self.build(plays, performance_data)
      play = plays[performance_data["playID"]]
      new(
        play_name: play["name"],
        play_type: play["type"],
        seat_count: performance_data["audience"]
      )
    end

    def receive(message)
      case message
      in :price then compute_price
      in :credits then compute_credits
      in :format then format_line
      end
    end

    private

    def compute_price
      case play_type
      when "comedy"
        result = 30000 + (300 * seat_count)
        result += 10000 + (500 * (seat_count - 20)) if seat_count > 20
        result
      when "tragedy"
        result = 40000
        result += 1000 * (seat_count - 30) if seat_count > 30
        result
      else
        raise "unknown type: #{play_type}"
      end
    end

    def compute_credits
      base = [seat_count - 30, 0].max
      case play_type
      when "comedy" then base + (seat_count / 5).floor
      when "tragedy" then base
      else raise "unknown type: #{play_type}"
      end
    end

    def format_line
      format(" %s: %s (%s seats)", play_name, usd(compute_price), seat_count)
    end

    def usd(amount) = format("$%.2f", amount / 100.0)
  end

  class StatementCoordinator
    def initialize(invoice, plays)
      @customer = invoice["customer"]
      @performances = invoice["performances"].map { Performance.build(plays, it) }
    end

    def render
      [
        "Statement for #{@customer}",
        @performances.map { it.receive(:format) },
        "Amount owed is #{usd(total_price)}",
        "You earned #{total_credits} credits",
      ].join("\n").concat("\n")
    end

    private

    def total_price = @performances.sum { it.receive(:price) }
    def total_credits = @performances.sum { it.receive(:credits) }
    def usd(amount) = format("$%.2f", amount / 100.0)
  end

  def statement(invoice, plays) = StatementCoordinator.new(invoice, plays).render
end
