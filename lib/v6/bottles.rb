module BottlesKata
  # Polymorphic verse classes - no case statements, no else
  class BottleNumber
    def self.for(number)
      case number
      when 0 then BottleNumber0.new(number)
      when 1 then BottleNumber1.new(number)
      else BottleNumber.new(number)
      end
    end

    attr_reader :number

    def initialize(number)
      @number = number
    end

    def container = "bottles"
    def pronoun = "one"
    def quantity = number.to_s
    def action = "Take #{pronoun} down and pass it around"
    def successor = BottleNumber.for(number - 1)

    def to_s
      "#{quantity} #{container}"
    end
  end

  class BottleNumber0 < BottleNumber
    def quantity = "no more"
    def action = "Go to the store and buy some more"
    def successor = BottleNumber.for(99)
  end

  class BottleNumber1 < BottleNumber
    def container = "bottle"
    def pronoun = "it"
  end

  class Bottles
    def verse(number)
      bottle_number = BottleNumber.for(number)
      successor = bottle_number.successor
      "#{bottle_number.to_s.capitalize} of beer on the wall, " +
        "#{bottle_number} of beer.\n" +
        "#{bottle_number.action}, " +
        "#{successor} of beer on the wall.\n"
    end

    def verses(start, finish)
      start.downto(finish).map { |n| verse(n) }.join("\n")
    end

    def song
      verses(99, 0)
    end
  end
end
