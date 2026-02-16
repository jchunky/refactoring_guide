module BottlesKata
  class Bottles
    def verse(number)
      "#{bottle_count(number).capitalize} of beer on the wall, " \
      "#{bottle_count(number)} of beer.\n" \
      "#{action(number)}, " \
      "#{bottle_count(next_bottle(number))} of beer on the wall.\n"
    end

    def verses(start, finish)
      start.downto(finish).map { |num| verse(num) }.join("\n")
    end

    def song
      verses(99, 0)
    end

    private

    def bottle_count(number)
      case number
      when 0 then "no more bottles"
      when 1 then "1 bottle"
      else "#{number} bottles"
      end
    end

    def action(number)
      case number
      when 0 then "Go to the store and buy some more"
      when 1 then "Take it down and pass it around"
      else "Take one down and pass it around"
      end
    end

    def next_bottle(number)
      number == 0 ? 99 : number - 1
    end
  end
end
