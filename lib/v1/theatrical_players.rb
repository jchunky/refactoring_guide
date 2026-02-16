TRAGEDY_BASE_AMOUNT = 40_000
TRAGEDY_AUDIENCE_THRESHOLD = 30
TRAGEDY_PER_EXTRA_AUDIENCE = 1_000

COMEDY_BASE_AMOUNT = 30_000
COMEDY_AUDIENCE_THRESHOLD = 20
COMEDY_BONUS_AMOUNT = 10_000
COMEDY_PER_EXTRA_AUDIENCE = 500
COMEDY_PER_AUDIENCE = 300

VOLUME_CREDIT_THRESHOLD = 30
COMEDY_BONUS_CREDIT_DIVISOR = 5

def statement(invoice, plays)
  StatementPrinter.new(invoice, plays).generate
end

class StatementPrinter
  def initialize(invoice, plays)
    @invoice = invoice
    @plays = plays
  end

  def generate
    [
      header,
      performance_lines,
      footer
    ].join
  end

  private

  def header
    "Statement for #{@invoice['customer']}\n"
  end

  def performance_lines
    performances.map { |perf| performance_line(perf) }.join
  end

  def footer
    "Amount owed is #{format_amount(total_amount)}\n" \
    "You earned #{total_credits} credits\n"
  end

  def performances
    @invoice['performances']
  end

  def performance_line(perf)
    play = play_for(perf)
    " #{play['name']}: #{format_amount(amount_for(perf))} (#{perf['audience']} seats)\n"
  end

  def play_for(perf)
    @plays[perf['playID']]
  end

  def total_amount
    performances.sum { |perf| amount_for(perf) }
  end

  def total_credits
    performances.sum { |perf| credits_for(perf) }
  end

  def amount_for(perf)
    play = play_for(perf)
    audience = perf['audience']

    case play['type']
    when 'tragedy'
      tragedy_amount(audience)
    when 'comedy'
      comedy_amount(audience)
    else
      raise "unknown type: #{play['type']}"
    end
  end

  def tragedy_amount(audience)
    amount = TRAGEDY_BASE_AMOUNT
    amount += TRAGEDY_PER_EXTRA_AUDIENCE * (audience - TRAGEDY_AUDIENCE_THRESHOLD) if audience > TRAGEDY_AUDIENCE_THRESHOLD
    amount
  end

  def comedy_amount(audience)
    amount = COMEDY_BASE_AMOUNT
    amount += COMEDY_BONUS_AMOUNT + COMEDY_PER_EXTRA_AUDIENCE * (audience - COMEDY_AUDIENCE_THRESHOLD) if audience > COMEDY_AUDIENCE_THRESHOLD
    amount += COMEDY_PER_AUDIENCE * audience
    amount
  end

  def credits_for(perf)
    play = play_for(perf)
    audience = perf['audience']

    credits = [audience - VOLUME_CREDIT_THRESHOLD, 0].max
    credits += comedy_bonus_credits(audience) if play['type'] == 'comedy'
    credits
  end

  def comedy_bonus_credits(audience)
    (audience / COMEDY_BONUS_CREDIT_DIVISOR).floor
  end

  def format_amount(amount_in_cents)
    "$#{'%.2f' % (amount_in_cents / 100.0)}"
  end
end
