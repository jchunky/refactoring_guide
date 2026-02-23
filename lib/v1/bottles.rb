# frozen_string_literal: true

module BottlesKata
  class BottleNumber < Struct.new(:n)
    def self.for(n) = (Object.const_get("BottleNumber#{n}") rescue BottleNumber).new(n)

    def to_s = [quantity, bottles].join(" ")
    def successor = BottleNumber.for(n - 1)
    def quantity = n.to_s
    def bottles = "bottles"
    def pronoun = "one"
    def action = "Take #{pronoun} down and pass it around"
  end

  class BottleNumber0 < BottleNumber
    def to_s = [quantity, bottles].join(" ")
    def successor = BottleNumber.for(99)
    def quantity = "no more"
    def action = "Go to the store and buy some more"
  end

  class BottleNumber1 < BottleNumber
    def to_s = [quantity, bottles].join(" ")
    def bottles = "bottle"
    def pronoun = "it"
  end

  class Bottles
    def song = verses(99, 0)
    def verses(start, finish) = start.downto(finish).map(&method(:verse)).join("\n")

    def verse(number)
      n = BottleNumber.for(number)
      "#{n.to_s.capitalize} of beer on the wall, #{n} of beer.\n#{n.action}, #{n.successor} of beer on the wall.\n"
    end
  end
end
