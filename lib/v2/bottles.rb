# frozen_string_literal: true

module BottlesKata
  class BottleNumber < Data.define(:number)
    def self.for(n) = (Object.const_get("BottleNumber#{n}") rescue BottleNumber).new(n)

    def to_s = "#{number} bottles"
    def action = "Take one down and pass it around"
    def successor = BottleNumber.for(number - 1)
  end

  class BottleNumber0 < BottleNumber
    def to_s = "no more bottles"
    def action = "Go to the store and buy some more"
    def successor = BottleNumber.for(99)
  end

  class BottleNumber1 < BottleNumber
    def to_s = "1 bottle"
    def action = "Take it down and pass it around"
  end

  class Bottles
    def song = verses(99, 0)
    def verses(start, finish) = start.downto(finish).map { |n| verse(n) }.join("\n")

    def verse(number)
      n = BottleNumber.for(number)
      "#{n.to_s.capitalize} of beer on the wall, #{n} of beer.\n#{n.action}, #{n.successor} of beer on the wall.\n"
    end
  end
end
