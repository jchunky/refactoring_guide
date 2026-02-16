module EnglishNumberKata
  ONES = { 1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four', 5 => 'five',
           6 => 'six', 7 => 'seven', 8 => 'eight', 9 => 'nine' }.freeze

  TENS = { 1 => 'ten', 2 => 'twenty', 3 => 'thirty', 4 => 'forty', 5 => 'fifty',
           6 => 'sixty', 7 => 'seventy', 8 => 'eighty', 9 => 'ninety' }.freeze

  TEENS = { 11 => 'eleven', 12 => 'twelve', 13 => 'thirteen', 14 => 'fourteen',
            15 => 'fifteen', 16 => 'sixteen', 17 => 'seventeen', 18 => 'eighteen',
            19 => 'nineteen' }.freeze

  def english_number(number)
    return "Please enter a number that isn't negative." if number < 0
    return 'zero' if number.zero?

    parts = []
    hundreds, remainder = number.divmod(100)
    tens_digit, ones_digit = remainder.divmod(10)

    parts << "#{english_number(hundreds)} hundred" if hundreds > 0

    case [tens_digit, ones_digit]
    in [0, 0]
      # nothing to add
    in [1, (1..9)] # teens
      parts << TEENS[remainder]
    in [0, ones] # ones only
      parts << ONES[ones]
    in [tens, 0] # tens only
      parts << TENS[tens]
    in [tens, ones] # tens and ones
      parts << "#{TENS[tens]}-#{ONES[ones]}"
    end

    parts.join(' ')
  end
end
