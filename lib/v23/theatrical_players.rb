module TheatricalPlayersKata
  COMEDY_BONUS_THRESHOLD = 20
  TRAGEDY_BONUS_THRESHOLD = 30

  def statement(invoice, plays)
    total_amount = 0
    volume_credits = 0
    result = "Statement for #{invoice['customer']}\n"

    formatter = lambda { |amount| format("$%.2f", amount / 100.0) }

    invoice['performances'].each do |perf|
      play = plays[perf['playID']]
      amount = amount_for(play, perf)
      volume_credits += volume_credits_for(play, perf)

      result += " #{play['name']}: #{formatter.call(amount)} (#{perf['audience']} seats)\n"
      total_amount += amount
    end

    result += "Amount owed is #{formatter.call(total_amount)}\n"
    result += "You earned #{volume_credits} credits\n"
    result
  end

  def amount_for(play, perf)
    case play['type']
    when 'tragedy'
      tragedy_amount(perf['audience'])
    when 'comedy'
      comedy_amount(perf['audience'])
    else
      raise "unknown type: #{play['type']}"
    end
  end

  def tragedy_amount(audience)
    base = 40_000
    audience > TRAGEDY_BONUS_THRESHOLD ? base + 1000 * (audience - TRAGEDY_BONUS_THRESHOLD) : base
  end

  def comedy_amount(audience)
    base = 30_000
    if audience > COMEDY_BONUS_THRESHOLD
      base += 10_000 + 500 * (audience - COMEDY_BONUS_THRESHOLD)
    end
    base + 300 * audience
  end

  def volume_credits_for(play, perf)
    credits = [perf['audience'] - 30, 0].max
    credits += (perf['audience'] / 5).floor if play['type'] == 'comedy'
    credits
  end
end
