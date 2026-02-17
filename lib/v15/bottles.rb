module BottlesKata
  module BottleNumberFn
    def self.to_s(n)
      "#{quantity(n)} #{containers(n)}"
    end

    def self.quantity(n)
      case n
      in 0 then "no more"
      else n.to_s
      end
    end

    def self.containers(n)
      case n
      in 1 then "bottle"
      else "bottles"
      end
    end

    def self.action(n)
      case n
      in 0 then "Go to the store and buy some more"
      in 1 then "Take it down and pass it around"
      else "Take one down and pass it around"
      end
    end

    def self.successor(n)
      case n
      in 0 then 99
      else n - 1
      end
    end
  end

  class Bottles
    def song = verses(99, 0)
    def verses(start, finish) = start.downto(finish).map { verse(it) }.join("\n")

    def verse(number)
      current = BottleNumberFn.to_s(number)
      "#{current.capitalize} of beer on the wall, #{current} of beer.\n" \
        "#{BottleNumberFn.action(number)}, #{BottleNumberFn.to_s(BottleNumberFn.successor(number))} of beer on the wall.\n"
    end
  end
end
