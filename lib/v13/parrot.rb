module ParrotKata
  class Parrot
    BASE_SPEED = 12.0
    LOAD_FACTOR = 9.0
    MAX_VOLTAGE_SPEED = 24.0

    attr_reader :number_of_coconuts, :voltage, :nailed

    def self.new(type, number_of_coconuts = 0, voltage = 0, nailed = false)
      return super(number_of_coconuts, voltage, nailed) unless self == Parrot

      case type
      in :european_parrot       then European
      in :african_parrot        then African
      in :norwegian_blue_parrot then NorwegianBlue
      end.new(type, number_of_coconuts, voltage, nailed)
    end

    def initialize(number_of_coconuts, voltage, nailed)
      @number_of_coconuts = number_of_coconuts
      @voltage = voltage
      @nailed = nailed
    end
  end

  class Parrot::European < Parrot
    def speed = BASE_SPEED
  end

  class Parrot::African < Parrot
    def speed = [0, BASE_SPEED - LOAD_FACTOR * number_of_coconuts].max
  end

  class Parrot::NorwegianBlue < Parrot
    def speed = nailed ? 0 : [MAX_VOLTAGE_SPEED, voltage * BASE_SPEED].min
  end
end
