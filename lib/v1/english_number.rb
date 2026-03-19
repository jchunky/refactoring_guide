module EnglishNumberKata
  ONES = %w[one two three four five six seven eight nine].freeze
  TENS = %w[ten twenty thirty forty fifty sixty seventy eighty ninety].freeze
  TEENS = %w[eleven twelve thirteen fourteen fifteen
             sixteen seventeen eighteen nineteen].freeze

  def english_number(number)
    return 'Please enter a number that isn\'t negative.' if number < 0
    return 'zero' if number == 0

    parts = []
    remainder = number

    remainder = append_hundreds(parts, remainder)
    remainder = append_tens(parts, remainder)
    append_ones(parts, remainder)

    parts.join
  end

  private

  def append_hundreds(parts, remainder)
    hundreds, remainder = remainder.divmod(100)
    if hundreds > 0
      parts << "#{english_number(hundreds)} hundred"
      parts << ' ' if remainder > 0
    end
    remainder
  end

  def append_tens(parts, remainder)
    tens, ones = remainder.divmod(10)
    if tens > 0
      if tens == 1 && ones > 0
        parts << TEENS[ones - 1]
        return 0
      end
      parts << TENS[tens - 1]
      parts << '-' if ones > 0
    end
    ones
  end

  def append_ones(parts, remainder)
    parts << ONES[remainder - 1] if remainder > 0
  end
end
