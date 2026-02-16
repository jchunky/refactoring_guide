# Refactored using Primitive Obsession: NumberParts encapsulates digit extraction
# Data Clumps: Word arrays grouped into NumberWords
class NumberWords
  ONES = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
  TENS = ['ten', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety']
  TEENS = ['eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen']

  def self.ones(digit)
    ONES[digit - 1]
  end

  def self.tens(digit)
    TENS[digit - 1]
  end

  def self.teens(digit)
    TEENS[digit - 1]
  end
end

class NumberParts
  attr_reader :hundreds, :tens, :ones

  def initialize(number)
    @hundreds = number / 100
    remaining = number % 100
    @tens = remaining / 10
    @ones = remaining % 10
  end

  def teen?
    @tens == 1 && @ones > 0
  end

  def teen_value
    @ones
  end
end

def english_number(number)
  return "Please enter a number that isn't negative." if number < 0
  return 'zero' if number == 0

  parts = NumberParts.new(number)
  result = []

  if parts.hundreds > 0
    result << "#{english_number(parts.hundreds)} hundred"
  end

  if parts.teen?
    result << NumberWords.teens(parts.teen_value)
  else
    if parts.tens > 0
      tens_word = NumberWords.tens(parts.tens)
      if parts.ones > 0
        result << "#{tens_word}-#{NumberWords.ones(parts.ones)}"
      else
        result << tens_word
      end
    elsif parts.ones > 0
      result << NumberWords.ones(parts.ones)
    end
  end

  result.join(' ')
end
