# Theatrical Players Kata
#
# Generates billing statements for theatrical performances.
# Calculates costs based on play type and audience size,
# and awards volume credits for customer loyalty.
#
# Pricing rules:
# - Tragedy: Base $400, +$10 per audience over 30
# - Comedy: Base $300, +$100 bonus if audience > 20, +$5 per audience over 20, +$3 per total audience
#
# Volume credits:
# - All plays: 1 credit per audience over 30
# - Comedy bonus: 1 credit per 5 audience members

module TheatricalPlayersKata
  # Pricing constants (in cents to avoid floating point issues)
  PRICING = {
    tragedy: {
      base_amount_cents: 40_000,
      per_audience_over_threshold_cents: 1_000,
      audience_threshold: 30
    },
    comedy: {
      base_amount_cents: 30_000,
      high_attendance_bonus_cents: 10_000,
      per_audience_over_threshold_cents: 500,
      per_audience_cents: 300,
      audience_threshold: 20
    }
  }.freeze

  # Volume credits configuration
  VOLUME_CREDITS = {
    base_threshold: 30,
    comedy_divisor: 5
  }.freeze

  # Generate a billing statement for a customer's performances
  #
  # @param invoice [Hash] Contains 'customer' name and 'performances' array
  # @param plays [Hash] Play catalog keyed by playID with 'name' and 'type'
  # @return [String] Formatted billing statement
  def statement(invoice, plays)
    statement_data = calculate_statement_data(invoice, plays)
    format_statement(statement_data)
  end

  private

  # Calculate all data needed for the statement
  def calculate_statement_data(invoice, plays)
    performances_data = invoice['performances'].map do |performance|
      play = plays[performance['playID']]
      calculate_performance_data(performance, play)
    end

    {
      customer: invoice['customer'],
      performances: performances_data,
      total_amount_cents: performances_data.sum { |p| p[:amount_cents] },
      total_volume_credits: performances_data.sum { |p| p[:volume_credits] }
    }
  end

  # Calculate amount and credits for a single performance
  def calculate_performance_data(performance, play)
    audience = performance['audience']
    play_type = play['type'].to_sym

    {
      play_name: play['name'],
      audience: audience,
      amount_cents: calculate_amount_cents(play_type, audience),
      volume_credits: calculate_volume_credits(play_type, audience)
    }
  end

  # Calculate the cost for a performance based on play type and audience
  def calculate_amount_cents(play_type, audience)
    case play_type
    when :tragedy
      calculate_tragedy_amount(audience)
    when :comedy
      calculate_comedy_amount(audience)
    else
      raise "unknown type: #{play_type}"
    end
  end

  # Tragedy pricing: $400 base + $10 per audience over 30
  def calculate_tragedy_amount(audience)
    config = PRICING[:tragedy]
    amount = config[:base_amount_cents]

    if audience > config[:audience_threshold]
      excess_audience = audience - config[:audience_threshold]
      amount += config[:per_audience_over_threshold_cents] * excess_audience
    end

    amount
  end

  # Comedy pricing: $300 base + bonus for high attendance + per-audience fees
  def calculate_comedy_amount(audience)
    config = PRICING[:comedy]
    amount = config[:base_amount_cents]

    if audience > config[:audience_threshold]
      amount += config[:high_attendance_bonus_cents]
      excess_audience = audience - config[:audience_threshold]
      amount += config[:per_audience_over_threshold_cents] * excess_audience
    end

    # Additional per-audience charge for all comedy attendees
    amount += config[:per_audience_cents] * audience

    amount
  end

  # Calculate volume credits for a performance
  def calculate_volume_credits(play_type, audience)
    credits = 0

    # Base credits: 1 per audience over threshold
    excess_audience = [audience - VOLUME_CREDITS[:base_threshold], 0].max
    credits += excess_audience

    # Bonus credits for comedy: 1 per 5 audience members
    if play_type == :comedy
      credits += (audience / VOLUME_CREDITS[:comedy_divisor]).floor
    end

    credits
  end

  # Format the statement as a string
  def format_statement(data)
    lines = []
    lines << "Statement for #{data[:customer]}"

    data[:performances].each do |performance|
      formatted_amount = format_currency(performance[:amount_cents])
      lines << " #{performance[:play_name]}: #{formatted_amount} (#{performance[:audience]} seats)"
    end

    lines << "Amount owed is #{format_currency(data[:total_amount_cents])}"
    lines << "You earned #{data[:total_volume_credits]} credits"

    lines.join("\n") + "\n"
  end

  # Format cents as dollars with 2 decimal places
  def format_currency(amount_cents)
    "$#{'%.2f' % (amount_cents / 100.0)}"
  end
end
