module TheatricalPlayersKata
  # Refactored to fix Feature Envy: 
  # - Play calculates its own amount and credits
  # - Performance delegates to Play for calculations
  # - Ask objects to do things, don't reach into them

  class Play
    attr_reader :name, :type

    def initialize(data)
      @name = data['name']
      @type = data['type']
    end

    def amount_for(audience)
      raise NotImplementedError, 'Subclasses must implement amount_for'
    end

    def credits_for(audience)
      [audience - 30, 0].max
    end
  end

  class Tragedy < Play
    def amount_for(audience)
      amount = 40000
      amount += 1000 * (audience - 30) if audience > 30
      amount
    end
  end

  class Comedy < Play
    def amount_for(audience)
      amount = 30000
      amount += 10000 + 500 * (audience - 20) if audience > 20
      amount += 300 * audience
      amount
    end

    def credits_for(audience)
      super + (audience / 5).floor
    end
  end

  class PlayFactory
    def self.create(data)
      case data['type']
      when 'tragedy' then Tragedy.new(data)
      when 'comedy' then Comedy.new(data)
      else raise "unknown type: #{data['type']}"
      end
    end
  end

  class Performance
    attr_reader :play, :audience

    def initialize(perf_data, plays)
      @audience = perf_data['audience']
      @play = PlayFactory.create(plays[perf_data['playID']])
    end

    def amount
      play.amount_for(audience)
    end

    def credits
      play.credits_for(audience)
    end

    def play_name
      play.name
    end
  end

  class Invoice
    attr_reader :customer, :performances

    def initialize(invoice_data, plays)
      @customer = invoice_data['customer']
      @performances = invoice_data['performances'].map { |p| Performance.new(p, plays) }
    end

    def total_amount
      performances.sum(&:amount)
    end

    def total_credits
      performances.sum(&:credits)
    end
  end

  class StatementFormatter
    def initialize(invoice)
      @invoice = invoice
    end

    def format
      result = "Statement for #{@invoice.customer}\n"
    
      @invoice.performances.each do |perf|
        result += " #{perf.play_name}: #{format_amount(perf.amount)} (#{perf.audience} seats)\n"
      end

      result += "Amount owed is #{format_amount(@invoice.total_amount)}\n"
      result += "You earned #{@invoice.total_credits} credits\n"
      result
    end

    private

    def format_amount(amount)
      "$#{'%.2f' % (amount / 100.0)}"
    end
  end

  def statement(invoice_data, plays)
    invoice = Invoice.new(invoice_data, plays)
    StatementFormatter.new(invoice).format
  end
end
