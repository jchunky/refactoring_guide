module BottlesKata
  class Bottles
    STARTING_BOTTLES = 99

    def verse(number)
      "#{wall_phrase(number)}, #{beer_phrase(number)}.\n" \
        "#{action_phrase(number)}, #{next_wall_phrase(number)}.\n"
    end

    def verses(start, finish)
      result = []
      start.downto(finish) do |num|
        result << verse(num)
      end
      result.join("\n")
    end

    def song
      verses(STARTING_BOTTLES, 0)
    end

    private

    def wall_phrase(number)
      "#{bottle_phrase(number)} of beer on the wall"
    end

    def beer_phrase(number)
      phrase = bottle_phrase(number)
      phrase = phrase.downcase if number.zero?
      "#{phrase} of beer"
    end

    def bottle_phrase(number)
      return "No more bottles" if number.zero?
      return "1 bottle" if number == 1

      "#{number} bottles"
    end

    def action_phrase(number)
      return "Go to the store and buy some more" if number.zero?
      return "Take it down and pass it around" if number == 1

      "Take one down and pass it around"
    end

    def next_count(number)
      number.zero? ? STARTING_BOTTLES : number - 1
    end

    def next_wall_phrase(number)
      next_number = next_count(number)
      phrase = bottle_phrase(next_number)
      phrase = phrase.downcase if number == 1
      "#{phrase} of beer on the wall"
    end
  end
end
