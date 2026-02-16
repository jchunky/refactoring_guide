class Play < Struct.new(:name, :type, keyword_init: true)
  def self.from_hash(hash) = new(name: hash['name'], type: hash['type'])
end

class Performance < Struct.new(:play, :audience, keyword_init: true)
  def amount
    case play.type
    when 'tragedy' then tragedy_amount
    when 'comedy' then comedy_amount
    else raise "unknown type: #{play.type}"
    end
  end

  def volume_credits
    base_credits + comedy_bonus
  end

  private

  def tragedy_amount
    base = 40_000
    base += 1000 * (audience - 30) if audience > 30
    base
  end

  def comedy_amount
    base = 30_000
    base += 10_000 + 500 * (audience - 20) if audience > 20
    base + 300 * audience
  end

  def base_credits = [audience - 30, 0].max
  def comedy_bonus = play.type == 'comedy' ? audience / 5 : 0
end

class Statement < Struct.new(:customer, :performances, keyword_init: true)
  def to_s
    [
      "Statement for #{customer}",
      *line_items,
      "Amount owed is #{format_currency(total_amount)}",
      "You earned #{total_credits} credits"
    ].join("\n") + "\n"
  end

  private

  def line_items
    performances.map do |perf|
      " #{perf.play.name}: #{format_currency(perf.amount)} (#{perf.audience} seats)"
    end
  end

  def total_amount = performances.sum(&:amount)
  def total_credits = performances.sum(&:volume_credits)
  def format_currency(cents) = format("$%.2f", cents / 100.0)
end

def statement(invoice, plays)
  performances = invoice['performances'].map do |perf|
    play = Play.from_hash(plays[perf['playID']])
    Performance.new(play:, audience: perf['audience'])
  end

  Statement.new(customer: invoice['customer'], performances:).to_s
end
