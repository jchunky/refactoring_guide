module TheatricalPlayersKata
  def statement(invoice, plays)
    performances = invoice['performances'].map { |perf| enrich(perf, plays) }
    total_amount = performances.sum { |p| p[:amount] }
    total_credits = performances.sum { |p| p[:credits] }

    lines = ["Statement for #{invoice['customer']}"]
    performances.each do |perf|
      lines << " #{perf[:name]}: #{format_currency(perf[:amount])} (#{perf[:audience]} seats)"
    end
    lines << "Amount owed is #{format_currency(total_amount)}"
    lines << "You earned #{total_credits} credits"
    lines.join("\n") + "\n"
  end

  private

  def enrich(performance, plays)
    play = plays[performance['playID']]
    audience = performance['audience']

    {
      name: play['name'],
      audience: audience,
      amount: amount_for(play['type'], audience),
      credits: credits_for(play['type'], audience)
    }
  end

  def amount_for(type, audience)
    case type
    when 'tragedy'
      base = 40_000
      base += 1_000 * (audience - 30) if audience > 30
      base
    when 'comedy'
      base = 30_000
      base += 10_000 + 500 * (audience - 20) if audience > 20
      base + 300 * audience
    else
      raise "unknown type: #{type}"
    end
  end

  def credits_for(type, audience)
    credits = [audience - 30, 0].max
    credits += (audience / 5).floor if type == 'comedy'
    credits
  end

  def format_currency(amount_in_cents)
    "$#{'%.2f' % (amount_in_cents / 100.0)}"
  end
end
