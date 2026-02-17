module BottlesKata
  BottleNumber = Data.define(:n)

  module BottleNumberFn
    def self.to_s(bn)
      "#{quantity(bn)} #{containers(bn)}"
    end

    def self.quantity(bn)
      case bn
      in BottleNumber[n: 0] then "no more"
      in BottleNumber[n:] then n.to_s
      end
    end

    def self.containers(bn)
      case bn
      in BottleNumber[n: 1] then "bottle"
      in BottleNumber then "bottles"
      end
    end

    def self.action(bn)
      case bn
      in BottleNumber[n: 0] then "Go to the store and buy some more"
      in BottleNumber[n: 1] then "Take it down and pass it around"
      in BottleNumber then "Take one down and pass it around"
      end
    end

    def self.successor(bn)
      case bn
      in BottleNumber[n: 0] then BottleNumber.new(n: 99)
      in BottleNumber[n:] then BottleNumber.new(n: n - 1)
      end
    end
  end

  class Bottles
    def song = verses(99, 0)
    def verses(start, finish) = start.downto(finish).map { verse(it) }.join("\n")

    def verse(number)
      bn = BottleNumber.new(n: number)
      current = BottleNumberFn.to_s(bn)
      successor_str = BottleNumberFn.to_s(BottleNumberFn.successor(bn))
      "#{current.capitalize} of beer on the wall, #{current} of beer.\n" \
        "#{BottleNumberFn.action(bn)}, #{successor_str} of beer on the wall.\n"
    end
  end
end
