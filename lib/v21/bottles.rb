module BottlesKata
  # Protocol: every bottle number type must implement these
  module BottleNumberProtocol
    def to_s = raise NotImplementedError
    def action = raise NotImplementedError
    def successor = raise NotImplementedError
  end

  class RegularBottleNumber
    include BottleNumberProtocol

    def initialize(n) = @n = n
    def to_s = "#{@n} bottles"
    def action = "Take one down and pass it around"
    def successor = BottleNumberRegistry.for(@n - 1)
  end

  class ZeroBottleNumber
    include BottleNumberProtocol

    def to_s = "no more bottles"
    def action = "Go to the store and buy some more"
    def successor = BottleNumberRegistry.for(99)
  end

  class OneBottleNumber
    include BottleNumberProtocol

    def to_s = "1 bottle"
    def action = "Take it down and pass it around"
    def successor = BottleNumberRegistry.for(0)
  end

  module BottleNumberRegistry
    TYPES = { 0 => ZeroBottleNumber, 1 => OneBottleNumber }.freeze

    def self.for(n)
      klass = TYPES.fetch(n, RegularBottleNumber)
      klass == RegularBottleNumber ? klass.new(n) : klass.new
    end
  end

  class Bottles
    def song = verses(99, 0)
    def verses(start, finish) = start.downto(finish).map { verse(it) }.join("\n")

    def verse(number)
      n = BottleNumberRegistry.for(number)
      "#{n.to_s.capitalize} of beer on the wall, #{n} of beer.\n#{n.action}, #{n.successor} of beer on the wall.\n"
    end
  end
end
