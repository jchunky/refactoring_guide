module EnglishNumberKata
  def english_number(number)
    return 'Please enter a number that isn\'t negative.' if number < 0
    return 'zero' if number == 0

    ones_place = ['one',     'two',       'three',    'four',     'five',
                  'six',     'seven',     'eight',    'nine']
    tens_place = ['ten',     'twenty',    'thirty',   'forty',    'fifty',
                  'sixty',   'seventy',   'eighty',   'ninety']
    teenagers  = ['eleven',  'twelve',    'thirteen', 'fourteen', 'fifteen',
                  'sixteen', 'seventeen', 'eighteen', 'nineteen']

    num_string = ''
    left = number

    # Hundreds (recursive)
    hundreds = left / 100
    left = left - hundreds * 100

    if hundreds > 0
      num_string = english_number(hundreds) + ' hundred'
      num_string += ' ' if left > 0
    end

    # Tens
    tens = left / 10
    left = left - tens * 10

    if tens > 0
      if tens == 1 && left > 0
        num_string += teenagers[left - 1]
        left = 0
      else
        num_string += tens_place[tens - 1]
      end
      num_string += '-' if left > 0
    end

    # Ones
    num_string += ones_place[left - 1] if left > 0

    num_string
  end
end
