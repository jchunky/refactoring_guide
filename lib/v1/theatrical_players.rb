module TheatricalPlayersKata
  def statement(invoice, plays)
    total_amount = 0
    volume_credits = 0
    result = "Statement for #{invoice['customer']}\n"

    invoice['performances'].each do |perf|
      play = plays[perf['playID']]
      amount = amount_for(play, perf)
      volume_credits += credits_for(play, perf)

      result += " #{play['name']}: #{format_currency(amount)} (#{perf['audience']} seats)\n"
      total_amount += amount
    end

    result += "Amount owed is #{format_currency(total_amount)}\n"
    result += "You earned #{volume_credits} credits\n"
    result
  end

  private

  def amount_for(play, perf)
    audience = perf['audience']
    case play['type']
    when 'tragedy'
      base = 40_000
      base += 1000 * (audience - 30) if audience > 30
      base
    when 'comedy'
      base = 30_000
      base += 10_000 + 500 * (audience - 20) if audience > 20
      base + 300 * audience
    else
      raise "unknown type: #{play['type']}"
    end
  end

  def credits_for(play, perf)
    credits = [perf['audience'] - 30, 0].max
    credits += (perf['audience'] / 5).floor if play['type'] == 'comedy'
    credits
  end

  def format_currency(amount)
    "$#{'%.2f' % (amount / 100.0)}"
  end
end
