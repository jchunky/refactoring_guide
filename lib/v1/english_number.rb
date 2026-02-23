# frozen_string_literal: true

module EnglishNumberKata
  ONES = %w[one two three four five six seven eight nine].freeze
  TEENS = %w[eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen].freeze
  TENS = %w[ten twenty thirty forty fifty sixty seventy eighty ninety].freeze

  def english_number(number)
    return "Please enter a number that isn't negative." if number < 0
    return "zero" if number == 0

    result = +""

    hundreds, remainder = number.divmod(100)
    if hundreds > 0
      result << "#{english_number(hundreds)} hundred"
      result << " " if remainder > 0
    end

    tens, ones = remainder.divmod(10)
    if tens > 0
      if tens == 1 && ones > 0
        result << TEENS[ones - 1]
        return result
      else
        result << TENS[tens - 1]
        result << "-" if ones > 0
      end
    end

    result << ONES[ones - 1] if ones > 0

    result
  end
end
