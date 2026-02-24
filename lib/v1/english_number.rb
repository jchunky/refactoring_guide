module EnglishNumberKata
  ONES = %w[one two three four five six seven eight nine].freeze
  TEENS = %w[eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen].freeze
  TENS = %w[ten twenty thirty forty fifty sixty seventy eighty ninety].freeze

  def english_number(number)
    return "Please enter a number that isn't negative." if number < 0
    return "zero" if number.zero?

    convert(number)
  end

  private

  def convert(number)
    parts = []

    hundreds, remainder = number.divmod(100)
    if hundreds > 0
      parts << "#{convert(hundreds)} hundred"
    end

    tens, ones = remainder.divmod(10)
    if tens == 1 && ones > 0
      parts << TEENS[ones - 1]
    else
      tens_and_ones = []
      tens_and_ones << TENS[tens - 1] if tens > 0
      tens_and_ones << ONES[ones - 1] if ones > 0
      parts << tens_and_ones.join("-") unless tens_and_ones.empty?
    end

    parts.join(" ")
  end
end
