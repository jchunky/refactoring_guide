module ParrotKata
  BASE_SPEED = 12.0

  class Parrot
    TYPES = {
      european_parrot: "EuropeanParrot",
      african_parrot: "AfricanParrot",
      norwegian_blue_parrot: "NorwegianBlueParrot",
    }.freeze

    def self.new(type, number_of_coconuts = 0, voltage = 0, nailed = false)
      klass = ParrotKata.const_get(TYPES.fetch(type))
      klass.allocate.tap { |obj| obj.send(:initialize, number_of_coconuts, voltage, nailed) }
    end
  end

  class EuropeanParrot
    def initialize(_coconuts, _voltage, _nailed) = nil

    def speed = BASE_SPEED
  end

  class AfricanParrot
    LOAD_FACTOR = 9.0

    def initialize(number_of_coconuts, _voltage, _nailed)
      @number_of_coconuts = number_of_coconuts
    end

    def speed
      [0, BASE_SPEED - LOAD_FACTOR * @number_of_coconuts].max
    end
  end

  class NorwegianBlueParrot
    MAX_SPEED = 24.0

    def initialize(_coconuts, voltage, nailed)
      @voltage = voltage
      @nailed = nailed
    end

    def speed
      @nailed ? 0 : [MAX_SPEED, @voltage * BASE_SPEED].min
    end
  end
end
