module EnglishNumberKata
  # Refactored using 99 Bottles of OOP principles:
  # - Extract meaningful names for concepts
  # - Small methods that do one thing
  # - Removed excessive comments (code should be self-documenting)

  def english_number(number)
    return 'Please enter a number that isn\'t negative.' if number < 0
    return 'zero' if number == 0

    NumberToWords.new(number).convert
  end

  class NumberToWords
    ONES = ['one', 'two', 'three', 'four', 'five',
            'six', 'seven', 'eight', 'nine']
    TENS = ['ten', 'twenty', 'thirty', 'forty', 'fifty',
            'sixty', 'seventy', 'eighty', 'ninety']
    TEENS = ['eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen',
             'sixteen', 'seventeen', 'eighteen', 'nineteen']

    def initialize(number)
      @number = number
    end

    def convert
      parts = []
      remaining = @number

      hundreds, remaining = extract_hundreds(remaining)
      parts << hundreds if hundreds

      tens_and_ones = convert_tens_and_ones(remaining)
      parts << tens_and_ones if tens_and_ones

      parts.join(' ')
    end

    private

    def extract_hundreds(number)
      hundreds_count = number / 100
      remaining = number % 100

      if hundreds_count > 0
        hundreds_word = "#{NumberToWords.new(hundreds_count).convert} hundred"
        [hundreds_word, remaining]
      else
        [nil, remaining]
      end
    end

    def convert_tens_and_ones(number)
      return nil if number == 0

      tens_count = number / 10
      ones_count = number % 10

      if tens_count == 1 && ones_count > 0
        TEENS[ones_count - 1]
      elsif tens_count > 0 && ones_count > 0
        "#{TENS[tens_count - 1]}-#{ONES[ones_count - 1]}"
      elsif tens_count > 0
        TENS[tens_count - 1]
      else
        ONES[ones_count - 1]
      end
    end
  end
end
