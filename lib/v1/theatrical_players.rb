# frozen_string_literal: true

module TheatricalPlayersKata
  def statement(invoice, plays)
    performances = invoice["performances"].map do |perf|
      play = plays[perf["playID"]]
      audience = perf["audience"]
      amount = amount_for(play, audience)
      credits = credits_for(play, audience)
      { play: play, audience: audience, amount: amount, credits: credits }
    end

    total_amount = performances.sum { |p| p[:amount] }
    total_credits = performances.sum { |p| p[:credits] }

    result = "Statement for #{invoice["customer"]}\n"
    performances.each do |perf|
      result += " #{perf[:play]["name"]}: #{format_usd(perf[:amount])} (#{perf[:audience]} seats)\n"
    end
    result += "Amount owed is #{format_usd(total_amount)}\n"
    result += "You earned #{total_credits} credits\n"
    result
  end

  private

  def amount_for(play, audience)
    case play["type"]
    when "tragedy"
      base = 40_000
      base += 1_000 * (audience - 30) if audience > 30
      base
    when "comedy"
      base = 30_000 + (300 * audience)
      base += 10_000 + (500 * (audience - 20)) if audience > 20
      base
    else
      raise "unknown type: #{play["type"]}"
    end
  end

  def credits_for(play, audience)
    credits = [audience - 30, 0].max
    credits += (audience / 5).floor if play["type"] == "comedy"
    credits
  end

  def format_usd(amount_in_cents)
    "$#{format("%.2f", amount_in_cents / 100.0)}"
  end
end
