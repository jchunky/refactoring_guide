module TheatricalPlayersKata
  # ═══════════════════════════════════════════════════════════════
  # FUNCTIONAL CORE
  #
  # Pure functions. No I/O, no mutation, no side effects.
  # Given an invoice and plays, computes amounts, credits, and
  # the full statement string.
  # ═══════════════════════════════════════════════════════════════

  module Core
    def self.amount_for(play_type, audience)
      case play_type
      when "tragedy"
        base = 40_000
        base += 1_000 * (audience - 30) if audience > 30
        base
      when "comedy"
        base = 30_000
        base += 10_000 + 500 * (audience - 20) if audience > 20
        base + 300 * audience
      else
        raise "unknown type: #{play_type}"
      end
    end

    def self.credits_for(play_type, audience)
      credits = [audience - 30, 0].max
      credits += (audience / 5).floor if play_type == "comedy"
      credits
    end

    def self.format_currency(cents)
      "$#{'%.2f' % (cents / 100.0)}"
    end

    def self.generate_statement(invoice, plays)
      result = "Statement for #{invoice['customer']}\n"

      total_amount = 0
      total_credits = 0

      invoice["performances"].each do |perf|
        play = plays[perf["playID"]]
        amount = amount_for(play["type"], perf["audience"])
        total_credits += credits_for(play["type"], perf["audience"])
        total_amount += amount

        result += " #{play['name']}: #{format_currency(amount)} (#{perf['audience']} seats)\n"
      end

      result += "Amount owed is #{format_currency(total_amount)}\n"
      result += "You earned #{total_credits} credits\n"
      result
    end
  end

  # ═══════════════════════════════════════════════════════════════
  # IMPERATIVE SHELL
  #
  # The public API. In this kata the shell is trivially thin because
  # `statement` already takes data in and returns a string (no I/O).
  # It simply delegates to the Core.
  # ═══════════════════════════════════════════════════════════════

  def statement(invoice, plays)
    Core.generate_statement(invoice, plays)
  end
end
