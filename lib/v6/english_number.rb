def english_number(number)
  return 'Please enter a number that isn\'t negative.' if number < 0
  return 'zero' if number == 0
  convert_number(number)
end

private

def convert_number(number)
  result = hundreds_part(number)
  result += tens_part(number % 100)
  result += ones_part(number % 100)
  result.strip
end

def hundreds_part(number)
  hundreds = number / 100
  return '' if hundreds == 0
  space = (number % 100 > 0) ? ' ' : ''
  "#{english_number(hundreds)} hundred#{space}"
end

def tens_part(number)
  tens = number / 10
  ones = number % 10
  return teenagers[ones - 1] if tens == 1 && ones > 0
  return '' if tens == 0
  suffix = (ones > 0) ? '-' : ''
  "#{tens_place[tens - 1]}#{suffix}"
end

def ones_part(number)
  return '' if number / 10 == 1 && number % 10 > 0
  ones = number % 10
  return '' if ones == 0
  ones_place[ones - 1]
end

def ones_place
  ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
end

def tens_place
  ['ten', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety']
end

def teenagers
  ['eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen']
end
