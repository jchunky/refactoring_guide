def statement(invoice, plays)
  total_amount = 0
  volume_credits = 0
  result = "Statement for #{invoice['customer']}\n"

  invoice['performances'].each do |perf|
    play = plays[perf['playID']]
    this_amount = calculate_amount(play, perf['audience'])
    volume_credits += calculate_credits(play, perf['audience'])

    result += " #{play['name']}: #{format_currency(this_amount)} (#{perf['audience']} seats)\n"
    total_amount += this_amount
  end

  result += "Amount owed is #{format_currency(total_amount)}\n"
  result += "You earned #{volume_credits} credits\n"
  result
end

private

def calculate_amount(play, audience)
  case play['type']
  when 'tragedy'
    40000 + (audience > 30 ? 1000 * (audience - 30) : 0)
  when 'comedy'
    30000 + 300 * audience + (audience > 20 ? 10000 + 500 * (audience - 20) : 0)
  else
    raise "unknown type: #{play['type']}"
  end
end

def calculate_credits(play, audience)
  credits = [audience - 30, 0].max
  credits += audience / 5 if play['type'] == 'comedy'
  credits
end

def format_currency(amount)
  "$#{'%.2f' % (amount / 100.0)}"
end
