module BottlesKata
  class BottleNumber < Data.define(:number)
    NAMES = { 0 => "no more", 1 => "1", 2 => "2" }.freeze

    def self.for(number)
      case number
      in 0 then Zero.new(number:)
      in 1 then One.new(number:)
      else      new(number:)
      end
    end

    def to_s = "#{number} bottles"
    def action = "Take one down and pass it around"
    def successor = BottleNumber.for(number - 1)
  end

  class BottleNumber::Zero < BottleNumber
    def to_s = "no more bottles"
    def action = "Go to the store and buy some more"
    def successor = BottleNumber.for(99)
  end

  class BottleNumber::One < BottleNumber
    def to_s = "1 bottle"
    def action = "Take it down and pass it around"
  end

  class Bottles
    def verse(number)
      bottle = BottleNumber.for(number)
      "#{bottle.to_s.capitalize} of beer on the wall, " \
        "#{bottle} of beer.\n" \
        "#{bottle.action}, " \
        "#{bottle.successor} of beer on the wall.\n"
    end

    def verses(start, finish) = start.downto(finish).map { verse(it) }.join("\n")

    def song = verses(99, 0)
  end
end
