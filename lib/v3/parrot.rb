module ParrotKata
  class ParrotBase < Struct.new(:number_of_coconuts, :voltage, :nailed, keyword_init: true)
    BASE_SPEED = 12.0

    def speed = BASE_SPEED
  end

  class EuropeanParrot < ParrotBase
    def speed = BASE_SPEED
  end

  class AfricanParrot < ParrotBase
    LOAD_FACTOR = 9.0

    def speed = [0, BASE_SPEED - LOAD_FACTOR * number_of_coconuts].max
  end

  class NorwegianBlueParrot < ParrotBase
    MAX_SPEED = 24.0

    def speed = nailed ? 0 : [MAX_SPEED, voltage * BASE_SPEED].min
  end

  # Factory class that maintains the original API
  class Parrot
    PARROT_TYPES = {
      european_parrot: EuropeanParrot,
      african_parrot: AfricanParrot,
      norwegian_blue_parrot: NorwegianBlueParrot
    }.freeze

    def initialize(type, number_of_coconuts, voltage, nailed)
      klass = PARROT_TYPES.fetch(type) { raise "Unknown parrot type: #{type}" }
      @parrot = klass.new(number_of_coconuts:, voltage:, nailed:)
    end

    def speed = @parrot.speed
  end
end
