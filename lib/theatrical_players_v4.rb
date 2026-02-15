def statement(invoice, plays)
  total_amount = 0
  volume_credits = 0
  result = "Statement for #{invoice['customer']}\n"

  invoice['performances'].each do |perf|
    play = plays[perf['playID']]
    amount = amount_for(play, perf['audience'])
    volume_credits += credits_for(play, perf['audience'])

    result += " #{play['name']}: #{format_usd(amount)} (#{perf['audience']} seats)\n"
    total_amount += amount
  end

  result += "Amount owed is #{format_usd(total_amount)}\n"
  result += "You earned #{volume_credits} credits\n"
  result
end

def amount_for(play, audience)
  case play['type']
  when 'tragedy'
    amount = 40000
    amount += 1000 * (audience - 30) if audience > 30
    amount
  when 'comedy'
    amount = 30000
    amount += 10000 + 500 * (audience - 20) if audience > 20
    amount + 300 * audience
  else
    raise "unknown type: #{play['type']}"
  end
end

def credits_for(play, audience)
  credits = [audience - 30, 0].max
  credits += audience / 5 if play['type'] == 'comedy'
  credits
end

def format_usd(cents)
  "$#{'%.2f' % (cents / 100.0)}"
end
