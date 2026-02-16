module TheatricalPlayersKata
  class Play
    attr_reader :name, :type

    def initialize(data)
      @name = data['name']
      @type = data['type']
    end

    def comedy?
      type == 'comedy'
    end

    def tragedy?
      type == 'tragedy'
    end
  end

  class Performance
    attr_reader :audience, :play

    def initialize(data, play)
      @audience = data['audience']
      @play = play
    end

    def amount
      case play.type
      when 'tragedy'
        result = 40_000
        result += 1000 * (audience - 30) if audience > 30
      when 'comedy'
        result = 30_000
        result += 10_000 + 500 * (audience - 20) if audience > 20
        result += 300 * audience
      else
        raise "unknown type: #{play.type}"
      end
      result
    end

    def volume_credits
      credits = [audience - 30, 0].max
      credits += (audience / 5).floor if play.comedy?
      credits
    end
  end

  def statement(invoice, plays)
    performances = invoice['performances'].map do |perf_data|
      play = Play.new(plays[perf_data['playID']])
      Performance.new(perf_data, play)
    end

    result = "Statement for #{invoice['customer']}\n"

    performances.each do |perf|
      result += " #{perf.play.name}: #{format_currency(perf.amount)} (#{perf.audience} seats)\n"
    end

    result += "Amount owed is #{format_currency(performances.sum(&:amount))}\n"
    result += "You earned #{performances.sum(&:volume_credits)} credits\n"
    result
  end

  private

  def format_currency(amount)
    "$#{'%.2f' % (amount / 100.0)}"
  end
end
