# English Number Kata
#
# Converts integers to their English word representation.
# Handles numbers from 0 to 999 (hundreds, tens, and ones).
#
# Examples:
#   0 → "zero"
#   15 → "fifteen"
#   42 → "forty-two"
#   100 → "one hundred"
#   319 → "three hundred nineteen"

module EnglishNumberKata
  # Word representations for ones place (1-9)
  ONES_WORDS = [
    'one', 'two', 'three', 'four', 'five',
    'six', 'seven', 'eight', 'nine'
  ].freeze

  # Word representations for tens place (10, 20, 30, ... 90)
  TENS_WORDS = [
    'ten', 'twenty', 'thirty', 'forty', 'fifty',
    'sixty', 'seventy', 'eighty', 'ninety'
  ].freeze

  # Special words for 11-19 (teens have unique names)
  TEEN_WORDS = [
    'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen',
    'sixteen', 'seventeen', 'eighteen', 'nineteen'
  ].freeze

  # Convert an integer to its English word representation
  #
  # @param number [Integer] The number to convert (must be non-negative)
  # @return [String] The English word representation
  def english_number(number)
    return 'Please enter a number that isn\'t negative.' if number < 0
    return 'zero' if number == 0

    result_parts = []
    remaining = number

    # Process hundreds place
    hundreds_count, remaining = extract_place_value(remaining, 100)
    if hundreds_count > 0
      hundreds_word = english_number(hundreds_count)
      result_parts << "#{hundreds_word} hundred"
    end

    # Process tens and ones places
    tens_ones_word = convert_tens_and_ones(remaining)
    result_parts << tens_ones_word if tens_ones_word

    result_parts.join(' ')
  end

  private

  # Extract the count at a given place value and return the remainder
  #
  # @param number [Integer] The number to extract from
  # @param place_value [Integer] The place value (100, 10, etc.)
  # @return [Array<Integer, Integer>] [count_at_place, remainder]
  def extract_place_value(number, place_value)
    count = number / place_value
    remainder = number % place_value
    [count, remainder]
  end

  # Convert a number from 1-99 to English words
  #
  # @param number [Integer] A number from 0-99
  # @return [String, nil] The English representation, or nil if 0
  def convert_tens_and_ones(number)
    return nil if number == 0

    tens_count, ones_count = extract_place_value(number, 10)

    # Handle teens (11-19) specially
    if tens_count == 1 && ones_count > 0
      return TEEN_WORDS[ones_count - 1]
    end

    result_parts = []

    # Add tens word (ten, twenty, thirty, etc.)
    result_parts << TENS_WORDS[tens_count - 1] if tens_count > 0

    # Add ones word (one, two, three, etc.)
    result_parts << ONES_WORDS[ones_count - 1] if ones_count > 0

    # Join with hyphen for compound numbers like "forty-two"
    if result_parts.length == 2
      result_parts.join('-')
    else
      result_parts.first
    end
  end
end
