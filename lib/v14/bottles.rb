module BottlesKata
  class BottleNumber < Data.define(:n)
    def self.for(n) = Object.const_get("BottleNumber#{n}").new(n) rescue BottleNumber.new(n)

    def to_s = [quantity, containers].join(" ")
    def action = "Take #{pronoun} down and pass it around"
    def successor = self.class.for(n - 1)
    def quantity = n.to_s
    def containers = "bottles"
    def pronoun = "one"
  end

  class BottleNumber0 < BottleNumber
    def action = "Go to the store and buy some more"
    def successor = self.class.for(99)
    def quantity = "no more"
  end

  class BottleNumber1 < BottleNumber
    def containers = "bottle"
    def pronoun = "it"
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
