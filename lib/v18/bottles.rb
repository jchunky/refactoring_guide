module BottlesKata
  class BottleNumber < Data.define(:n)
    def self.for(n) = new(n:)

    def to_s = "#{quantity} #{containers}"
    def successor = self.class.for(n == 0 ? 99 : n - 1)

    def action
      case n
      in 0 then "Go to the store and buy some more"
      in 1 then "Take it down and pass it around"
      else "Take one down and pass it around"
      end
    end

    private

    def quantity = n == 0 ? "no more" : n.to_s
    def containers = n == 1 ? "bottle" : "bottles"
  end

  class Bottles
    def song = verses(99, 0)
    def verses(start, finish) = start.downto(finish).map { verse(it) }.join("\n")

    def verse(number)
      n = BottleNumber.for(number)
      "#{n.to_s.capitalize} of beer on the wall, #{n} of beer.\n#{n.action}, #{n.successor} of beer on the wall.\n"
    end
  end
end
