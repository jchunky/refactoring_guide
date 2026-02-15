class Performance < Struct.new(:play_name, :play_type, :seat_count)
  def self.build(plays, performance_data)
    play = plays[performance_data["playID"]]
    play_type = play["type"]
    play_name = play["name"]
    seat_count = performance_data["audience"]
    performance_class = Object.const_get("#{play_type.capitalize}Performance") rescue (raise "unknown type: #{play_type}")
    performance_class.new(play_name:, play_type:, seat_count:)
  end
end

class ComedyPerformance < Performance
  def price = 30000 + (300 * seat_count) + (seat_count > 20 ? (10000 + (500 * (seat_count - 20))) : 0)
  def credits = [seat_count - 30, 0].max + (seat_count / 5).floor
end

class TragedyPerformance < Performance
  def price = 40000 + (seat_count > 30 ? (1000 * (seat_count - 30)) : 0)
  def credits = [seat_count - 30, 0].max
end

class Statement < Struct.new(:invoice, :plays)
  def to_s
    [
      "Statement for #{invoice["customer"]}",
      performances.map { format_performance(it) },
      "Amount owed is #{usd(total_price)}",
      "You earned #{total_credits} credits",
    ].join("\n").concat("\n")
  end

  private

  def format_performance(perf) = format(" %s: %s (%s seats)", perf.play_name, usd(perf.price), perf.seat_count)
  def usd(amount) = format("$%.2f", amount / 100.0)
  def total_price = performances.sum(&:price)
  def total_credits = performances.sum(&:credits)
  def performances = invoice["performances"].map { |performance_data| Performance.build(plays, performance_data) }
  def customer = invoice["customer"]
end

def statement(invoice, plays)
  Statement.new(invoice, plays).to_s
end
