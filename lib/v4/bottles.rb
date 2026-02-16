module BottlesKata
  class Bottles
    SCORE_WORDS = %w[no 1 2].freeze

    def verse(number)
      "#{bottles(number).capitalize} of beer on the wall, #{bottles(number)} of beer.\n" \
      "#{action(number)}, #{bottles(next_number(number))} of beer on the wall.\n"
    end

    def verses(start, finish)
      start.downto(finish).map { |n| verse(n) }.join("\n")
    end

    def song
      verses(99, 0)
    end

    private

    def bottles(n)
      "#{quantity(n)} #{container(n)}"
    end

    def quantity(n)
      n == 0 ? "no more" : n.to_s
    end

    def container(n)
      n == 1 ? "bottle" : "bottles"
    end

    def action(n)
      n == 0 ? "Go to the store and buy some more" : "Take #{pronoun(n)} down and pass it around"
    end

    def pronoun(n)
      n == 1 ? "it" : "one"
    end

    def next_number(n)
      n == 0 ? 99 : n - 1
    end
  end
end
