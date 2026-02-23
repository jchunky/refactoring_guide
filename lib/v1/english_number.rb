# frozen_string_literal: true

module EnglishNumberKata
  NUMBERS = {
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety",
  }.freeze

  def english_number(n)
    return "Please enter a number that isn't negative." if n < 0
    return "zero" if n == 0

    say(n)
  end

  def say(n)
    case n
    when (1..20) then NUMBERS[n]
    when (21..99) then [NUMBERS[n.truncate(-1)], NUMBERS[n % 10]].compact.join("-")
    when (100..) then [say(n / 100), "hundred", say(n % 100)].compact.join(" ")
    end
  end
end
