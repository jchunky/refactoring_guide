module EnglishNumberKata
  ONES = %w[one two three four five six seven eight nine].freeze
  TEENS = %w[eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen].freeze
  TENS = %w[ten twenty thirty forty fifty sixty seventy eighty ninety].freeze

  def english_number(number)
    return "Please enter a number that isn't negative." if number < 0
    return "zero" if number == 0

    left = number
    hundreds, left = left.divmod(100)
    tens, ones = left.divmod(10)

    parts = []
    parts << "#{english_number(hundreds)} hundred" if hundreds > 0

    case [tens, ones]
    in [1, 1..] then parts << TEENS[ones - 1]
    in [1.., 0] then parts << TENS[tens - 1]
    in [1.., _] then parts << "#{TENS[tens - 1]}-#{ONES[ones - 1]}"
    in [0, 1..] then parts << ONES[ones - 1]
    else nil
    end

    parts.join(" ")
  end
end
