module TheatricalPlayersKata
  class Play < Data.define(:name, :type)
    def self.for(data)
      case data["type"]
      when "tragedy" then Tragedy
      when "comedy"  then Comedy
      else raise "unknown type: #{data["type"]}"
      end.new(name: data["name"], type: data["type"])
    end

    def format_amount(amount) = "$#{'%.2f' % (amount / 100.0)}"
  end

  class Play::Tragedy < Play
    def amount(audience) = 40_000 + [audience - 30, 0].max * 1_000
    def credits(audience) = [audience - 30, 0].max
  end

  class Play::Comedy < Play
    def amount(audience)
      base = 30_000 + 300 * audience
      audience > 20 ? base + 10_000 + 500 * (audience - 20) : base
    end

    def credits(audience) = [audience - 30, 0].max + audience / 5
  end

  def statement(invoice, plays)
    performances = invoice["performances"].map { |perf|
      play = Play.for(plays[perf["playID"]])
      audience = perf["audience"]
      [play, audience]
    }

    total = performances.sum { |play, audience| play.amount(audience) }
    credits = performances.sum { |play, audience| play.credits(audience) }

    result = "Statement for #{invoice["customer"]}\n"
    performances.each do |play, audience|
      result += " #{play.name}: #{play.format_amount(play.amount(audience))} (#{audience} seats)\n"
    end
    result += "Amount owed is #{performances.first.first.format_amount(total)}\n"
    result += "You earned #{credits} credits\n"
    result
  end
end
