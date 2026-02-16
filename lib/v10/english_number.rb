module EnglishNumberKata
  ONES = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
  TENS = ['ten', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety']
  TEENS = ['eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen']

  def english_number(number)
    return "Please enter a number that isn't negative." if number < 0
    return 'zero' if number == 0

    result = ''
    left = number

    hundreds, left = left.divmod(100)
    if hundreds > 0
      result += "#{english_number(hundreds)} hundred"
      result += ' ' if left > 0
    end

    tens_digit, ones_digit = left.divmod(10)
    if tens_digit > 0
      if tens_digit == 1 && ones_digit > 0
        result += TEENS[ones_digit - 1]
        ones_digit = 0
      else
        result += TENS[tens_digit - 1]
        result += '-' if ones_digit > 0
      end
    end

    result += ONES[ones_digit - 1] if ones_digit > 0

    result
  end
end
