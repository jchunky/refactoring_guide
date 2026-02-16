module ParrotKata
  class Parrot
    BASE_SPEED = 12.0
    LOAD_FACTOR = 9.0
    MAX_NORWEGIAN_SPEED = 24.0

    def self.new(type, number_of_coconuts = 0, voltage = 0, nailed = false)
      case type
      when :european_parrot
        EuropeanParrot.allocate.tap { |p| p.send(:initialize, type, number_of_coconuts, voltage, nailed) }
      when :african_parrot
        AfricanParrot.allocate.tap { |p| p.send(:initialize, type, number_of_coconuts, voltage, nailed) }
      when :norwegian_blue_parrot
        NorwegianBlueParrot.allocate.tap { |p| p.send(:initialize, type, number_of_coconuts, voltage, nailed) }
      else
        raise "Unknown parrot type: #{type}"
      end
    end

    def initialize(type, number_of_coconuts, voltage, nailed)
      @type = type
      @number_of_coconuts = number_of_coconuts
      @voltage = voltage
      @nailed = nailed
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
    def speed
      [0, BASE_SPEED - LOAD_FACTOR * @number_of_coconuts].max
    end
  end

  class NorwegianBlueParrot < Parrot
    def speed
      @nailed ? 0 : [MAX_NORWEGIAN_SPEED, @voltage * BASE_SPEED].min
    end
  end
end
