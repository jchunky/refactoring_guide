module EnglishNumberKata
  ONES_PLACE = ["one", "two", "three", "four", "five",
                "six", "seven", "eight", "nine"].freeze
  TENS_PLACE = ["ten", "twenty", "thirty", "forty", "fifty",
                "sixty", "seventy", "eighty", "ninety"].freeze
  TEENAGERS = ["eleven", "twelve", "thirteen", "fourteen", "fifteen",
               "sixteen", "seventeen", "eighteen", "nineteen"].freeze

  def english_number(number)
    return "Please enter a number that isn't negative." if number < 0
    return "zero" if number == 0

    left = number
    result = ""

    hundreds = left / 100
    left -= hundreds * 100
    if hundreds.positive?
      result << "#{english_number(hundreds)} hundred"
      result << " " if left.positive?
    end

    tens = left / 10
    left -= tens * 10
    if tens.positive?
      if tens == 1 && left.positive?
        result << TEENAGERS[left - 1]
        left = 0
      else
        result << TENS_PLACE[tens - 1]
      end
      result << "-" if left.positive?
    end

    if left.positive?
      result << ONES_PLACE[left - 1]
    end

    result
  end
end
