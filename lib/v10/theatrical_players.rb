module TheatricalPlayersKata
  def statement(invoice, plays)
    result = "Statement for #{invoice['customer']}\n"

    invoice['performances'].each do |perf|
      play = plays[perf['playID']]
      result += " #{play['name']}: #{format_currency(amount_for(perf, play))} (#{perf['audience']} seats)\n"
    end

    result += "Amount owed is #{format_currency(total_amount(invoice, plays))}\n"
    result += "You earned #{total_volume_credits(invoice, plays)} credits\n"
    result
  end

  private

  def amount_for(performance, play)
    case play['type']
    when 'tragedy'
      amount = 40_000
      amount += 1000 * (performance['audience'] - 30) if performance['audience'] > 30
    when 'comedy'
      amount = 30_000
      amount += 10_000 + 500 * (performance['audience'] - 20) if performance['audience'] > 20
      amount += 300 * performance['audience']
    else
      raise "unknown type: #{play['type']}"
    end
    amount
  end

  def volume_credits_for(performance, play)
    credits = [performance['audience'] - 30, 0].max
    credits += (performance['audience'] / 5).floor if play['type'] == 'comedy'
    credits
  end

  def total_amount(invoice, plays)
    invoice['performances'].sum { |perf| amount_for(perf, plays[perf['playID']]) }
  end

  def total_volume_credits(invoice, plays)
    invoice['performances'].sum { |perf| volume_credits_for(perf, plays[perf['playID']]) }
  end

  def format_currency(amount)
    "$#{'%.2f' % (amount / 100.0)}"
  end
end
