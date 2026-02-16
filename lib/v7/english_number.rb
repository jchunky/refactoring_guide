def english_number(number)
  return "Please enter a number that isn't negative." if number < 0
  return 'zero' if number == 0

  ones = %w[one two three four five six seven eight nine]
  tens = %w[ten twenty thirty forty fifty sixty seventy eighty ninety]
  teens = %w[eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen]

  parts = []

  hundreds, remainder = number.divmod(100)
  parts << "#{english_number(hundreds)} hundred" if hundreds > 0

  tens_digit, ones_digit = remainder.divmod(10)

  if tens_digit == 1 && ones_digit > 0
    parts << teens[ones_digit - 1]
  else
    parts << tens[tens_digit - 1] if tens_digit > 0
    parts << ones[ones_digit - 1] if ones_digit > 0
  end

  result = parts.first || ''
  parts[1..-1].each do |part|
    separator = result.end_with?('hundred') ? ' ' : (ones.include?(part) ? '-' : ' ')
    result += separator + part
  end

  result
end
