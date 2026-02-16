module ParrotKata
  class Parrot
    BASE_SPEED = 12.0
    LOAD_FACTOR = 9.0
    MAX_SPEED = 24.0

    def initialize(type, number_of_coconuts, voltage, nailed)
      @type = type
      @number_of_coconuts = number_of_coconuts
      @voltage = voltage
      @nailed = nailed
    end

    def speed
      case @type
      when :european_parrot
        BASE_SPEED
      when :african_parrot
        [0, BASE_SPEED - LOAD_FACTOR * @number_of_coconuts].max
      when :norwegian_blue_parrot
        @nailed ? 0 : [MAX_SPEED, @voltage * BASE_SPEED].min
      else
        raise "Unknown parrot type: #{@type}"
      end
    end
  end
end
