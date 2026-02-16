module TheatricalPlayersKata
  # Polymorphic play types - no case statements
  class PlayCalculator
    def self.for(play, performance)
      type = play['type']
      raise "unknown type: #{type}" unless PLAY_TYPES.key?(type)
      PLAY_TYPES[type].new(play, performance)
    end

    attr_reader :play, :performance

    def initialize(play, performance)
      @play = play
      @performance = performance
    end

    def audience = performance['audience']
    def name = play['name']
  end

  class TragedyCalculator < PlayCalculator
    def amount
      base_amount + extra_audience_amount
    end

    def volume_credits
      [audience - 30, 0].max
    end

    private

    def base_amount = 40000
    def extra_audience_amount
      return 0 unless audience > 30
      1000 * (audience - 30)
    end
  end

  class ComedyCalculator < PlayCalculator
    def amount
      base_amount + extra_audience_amount + per_audience_amount
    end

    def volume_credits
      [audience - 30, 0].max + (audience / 5).floor
    end

    private

    def base_amount = 30000
    def per_audience_amount = 300 * audience
    def extra_audience_amount
      return 0 unless audience > 20
      10000 + 500 * (audience - 20)
    end
  end

  PLAY_TYPES = {
    'tragedy' => TragedyCalculator,
    'comedy' => ComedyCalculator
  }.freeze

  class StatementPrinter
    def initialize(invoice, plays)
      @invoice = invoice
      @plays = plays
    end

    def statement
      header + performance_lines + footer
    end

    private

    def header = "Statement for #{@invoice['customer']}\n"
    def footer = amount_line + credits_line
    def amount_line = "Amount owed is #{format_amount(total_amount)}\n"
    def credits_line = "You earned #{total_credits} credits\n"
    def format_amount(amount) = "$#{'%.2f' % (amount / 100.0)}"

    def performance_lines
      calculators.map { |calc| performance_line(calc) }.join
    end

    def performance_line(calc)
      " #{calc.name}: #{format_amount(calc.amount)} (#{calc.audience} seats)\n"
    end

    def total_amount = calculators.sum(&:amount)
    def total_credits = calculators.sum(&:volume_credits)

    def calculators
      @calculators ||= @invoice['performances'].map do |perf|
        PlayCalculator.for(@plays[perf['playID']], perf)
      end
    end
  end

  def statement(invoice, plays)
    StatementPrinter.new(invoice, plays).statement
  end
end
