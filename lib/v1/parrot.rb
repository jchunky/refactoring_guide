# frozen_string_literal: true

module ParrotKata
  class Parrot
    BASE_SPEED = 12.0
    MAX_SPEED = 24.0
    LOAD_FACTOR = 9.0

    def self.new(type, number_of_coconuts, voltage, nailed)
      case type
      when :european_parrot
        EuropeanParrot.allocate
      when :african_parrot
        AfricanParrot.allocate.tap { |p| p.send(:initialize_african, number_of_coconuts) }
      when :norwegian_blue_parrot
        NorwegianBlueParrot.allocate.tap { |p| p.send(:initialize_norwegian, voltage, nailed) }
      else
        raise "Unknown parrot type: #{type}"
      end
    end

    def speed
      raise NotImplementedError
    end
  end

  class EuropeanParrot < Parrot
    def speed
      BASE_SPEED
    end
  end

  class AfricanParrot < Parrot
    def initialize_african(number_of_coconuts)
      @number_of_coconuts = number_of_coconuts
    end

    def speed
      [0, BASE_SPEED - (LOAD_FACTOR * @number_of_coconuts)].max
    end
  end

  class NorwegianBlueParrot < Parrot
    def initialize_norwegian(voltage, nailed)
      @voltage = voltage
      @nailed = nailed
    end

    def speed
      @nailed ? 0 : [MAX_SPEED, @voltage * BASE_SPEED].min
    end
  end
end
