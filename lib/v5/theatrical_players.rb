# Refactored using 99 Bottles of OOP principles:
# - Extract class for Play concept with polymorphism
# - Extract class for Performance calculation
# - Replace conditionals with polymorphism
# - Open/Closed principle via factory method

class Play
  def self.for(play_data)
    case play_data['type']
    when 'tragedy' then Tragedy.new(play_data)
    when 'comedy' then Comedy.new(play_data)
    else raise "unknown type: #{play_data['type']}"
    end
  end

  def initialize(data)
    @name = data['name']
    @type = data['type']
  end

  attr_reader :name, :type

  def base_amount
    raise NotImplementedError
  end

  def audience_amount(audience)
    raise NotImplementedError
  end

  def volume_credits(audience)
    [audience - 30, 0].max
  end
end

class Tragedy < Play
  BASE_AMOUNT = 40_000
  AUDIENCE_THRESHOLD = 30
  PER_EXTRA_AUDIENCE = 1_000

  def amount_for(audience)
    result = BASE_AMOUNT
    result += PER_EXTRA_AUDIENCE * (audience - AUDIENCE_THRESHOLD) if audience > AUDIENCE_THRESHOLD
    result
  end
end

class Comedy < Play
  BASE_AMOUNT = 30_000
  AUDIENCE_THRESHOLD = 20
  BONUS_AMOUNT = 10_000
  PER_EXTRA_AUDIENCE = 500
  PER_AUDIENCE = 300

  def amount_for(audience)
    result = BASE_AMOUNT
    if audience > AUDIENCE_THRESHOLD
      result += BONUS_AMOUNT + PER_EXTRA_AUDIENCE * (audience - AUDIENCE_THRESHOLD)
    end
    result + PER_AUDIENCE * audience
  end

  def volume_credits(audience)
    super + (audience / 5).floor
  end
end

class Performance
  def initialize(data, play)
    @play_id = data['playID']
    @audience = data['audience']
    @play = play
  end

  attr_reader :audience, :play

  def amount
    play.amount_for(audience)
  end

  def volume_credits
    play.volume_credits(audience)
  end

  def play_name
    play.name
  end
end

class StatementPrinter
  def initialize(invoice, plays)
    @customer = invoice['customer']
    @performances = build_performances(invoice['performances'], plays)
  end

  def statement
    result = "Statement for #{@customer}\n"
    @performances.each do |perf|
      result += " #{perf.play_name}: #{format_amount(perf.amount)} (#{perf.audience} seats)\n"
    end
    result += "Amount owed is #{format_amount(total_amount)}\n"
    result += "You earned #{total_volume_credits} credits\n"
    result
  end

  private

  def build_performances(performance_data, plays)
    performance_data.map do |perf|
      play = Play.for(plays[perf['playID']])
      Performance.new(perf, play)
    end
  end

  def total_amount
    @performances.sum(&:amount)
  end

  def total_volume_credits
    @performances.sum(&:volume_credits)
  end

  def format_amount(amount)
    "$#{'%.2f' % (amount / 100.0)}"
  end
end

def statement(invoice, plays)
  StatementPrinter.new(invoice, plays).statement
end
