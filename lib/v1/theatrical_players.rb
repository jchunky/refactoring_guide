module TheatricalPlayersKata
  def statement(invoice, plays)
    total_amount = 0
    volume_credits = 0
    result = "Statement for #{invoice['customer']}\n"

    invoice['performances'].each do |perf|
      play = plays[perf['playID']]
      this_amount = 0

      case play['type']
      when 'tragedy'
        this_amount = 40000
        this_amount += 1000 * (perf['audience'] - 30) if perf['audience'] > 30
      when 'comedy'
        this_amount = 30000
        this_amount += 10000 + 500 * (perf['audience'] - 20) if perf['audience'] > 20
        this_amount += 300 * perf['audience']
      else
        raise "unknown type: #{play['type']}"
      end

      volume_credits += [perf['audience'] - 30, 0].max
      volume_credits += (perf['audience'] / 5).floor if play['type'] == 'comedy'

      result += " #{play['name']}: #{format_amount(this_amount)} (#{perf['audience']} seats)\n"
      total_amount += this_amount
    end

    result += "Amount owed is #{format_amount(total_amount)}\n"
    result += "You earned #{volume_credits} credits\n"
    result
  end

  private

  def format_amount(amount)
    "$#{'%.2f' % (amount / 100.0)}"
  end
end
