# frozen_string_literal: true

module ParrotKata
  class Parrot
    BASE_SPEED = 12.0
    MAX_SPEED = 24.0
    LOAD_FACTOR = 9.0

    def self.new(type, number_of_coconuts, voltage, nailed)
      case type
      when :european_parrot then EuropeanParrot.allocate
      when :african_parrot then AfricanParrot.allocate.tap { |p| p.send(:initialize, number_of_coconuts) }
      when :norwegian_blue_parrot then NorwegianBlueParrot.allocate.tap { |p| p.send(:initialize, voltage, nailed) }
      else raise "Unknown parrot type: #{type}"
      end
    end
  end

  class EuropeanParrot < Parrot
    def speed = BASE_SPEED
  end

  class AfricanParrot < Parrot
    def initialize(number_of_coconuts)
      @number_of_coconuts = number_of_coconuts
    end

    def speed = [0, BASE_SPEED - (LOAD_FACTOR * @number_of_coconuts)].max
  end

  class NorwegianBlueParrot < Parrot
    def initialize(voltage, nailed)
      @voltage = voltage
      @nailed = nailed
    end

    def speed = @nailed ? 0 : [MAX_SPEED, @voltage * BASE_SPEED].min
  end
end
