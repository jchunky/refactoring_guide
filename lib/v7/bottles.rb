module BottlesKata
  class Bottles
    SCORES = %w[no one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen]

    def verse(number)
      "#{bottles(number).capitalize} of beer on the wall, " +
      "#{bottles(number)} of beer.\n" +
      "#{action(number)}, " +
      "#{bottles(next_bottle(number))} of beer on the wall.\n"
    end

    def verses(start, finish)
      start.downto(finish).map { |n| verse(n) }.join("\n")
    end

    def song
      verses(99, 0)
    end

    private

    def bottles(n)
      case n
      when 0 then "no more bottles"
      when 1 then "1 bottle"
      else "#{n} bottles"
      end
    end

    def action(n)
      if n == 0
        "Go to the store and buy some more"
      else
        "Take #{n == 1 ? 'it' : 'one'} down and pass it around"
      end
    end

    def next_bottle(n)
      n == 0 ? 99 : n - 1
    end
  end
end
