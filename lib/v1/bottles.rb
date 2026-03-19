module BottlesKata
  class Bottles
    def verse(number)
      if number == 0
        "No more bottles of beer on the wall, " \
        "no more bottles of beer.\n" \
        "Go to the store and buy some more, " \
        "99 bottles of beer on the wall.\n"
      elsif number == 1
        "1 bottle of beer on the wall, " \
        "1 bottle of beer.\n" \
        "Take it down and pass it around, " \
        "no more bottles of beer on the wall.\n"
      else
        remaining = number - 1
        "#{number} bottles of beer on the wall, " \
        "#{number} bottles of beer.\n" \
        "Take one down and pass it around, " \
        "#{remaining} #{container(remaining)} of beer on the wall.\n"
      end
    end

    def verses(start, finish)
      start.downto(finish).map { |num| verse(num) }.join("\n")
    end

    def song
      verses(99, 0)
    end

    private

    def container(count)
      count == 1 ? "bottle" : "bottles"
    end
  end
end
