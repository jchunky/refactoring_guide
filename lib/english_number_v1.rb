ONES = %w[one two three four five six seven eight nine].freeze
TENS = %w[ten twenty thirty forty fifty sixty seventy eighty ninety].freeze
TEENS = %w[eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen].freeze

def english_number(number)
  return 'Please enter a number that isn\'t negative.' if number < 0
  return 'zero' if number == 0

  convert_to_english(number)
end

private

def convert_to_english(number)
  result = []
  remaining = number

  hundreds, remaining = remaining.divmod(100)
  result << hundreds_to_english(hundreds) if hundreds > 0

  tens, ones = remaining.divmod(10)
  result << tens_and_ones_to_english(tens, ones) if tens > 0 || ones > 0

  result.join(' ')
end

def hundreds_to_english(hundreds)
  "#{english_number(hundreds)} hundred"
end

def tens_and_ones_to_english(tens, ones)
  if tens == 1 && ones > 0
    TEENS[ones - 1]
  elsif tens > 0 && ones > 0
    "#{TENS[tens - 1]}-#{ONES[ones - 1]}"
  elsif tens > 0
    TENS[tens - 1]
  else
    ONES[ones - 1]
  end
end
