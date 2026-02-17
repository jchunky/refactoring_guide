module ParrotKata
  # Protocol: every parrot type must implement #base_speed
  module ParrotSpeedProtocol
    def base_speed = raise NotImplementedError
  end

  class EuropeanParrot
    include ParrotSpeedProtocol
    def initialize(coconuts:, voltage:) = nil
    def base_speed = 12
  end

  class AfricanParrot
    include ParrotSpeedProtocol
    def initialize(coconuts:, voltage:) = @coconuts = coconuts
    def base_speed = 12 - (9 * @coconuts)
  end

  class NorwegianBlueParrot
    include ParrotSpeedProtocol
    def initialize(coconuts:, voltage:) = @voltage = voltage
    def base_speed = @voltage * 12
  end

  PARROT_TYPES = {
    european_parrot: EuropeanParrot,
    african_parrot: AfricanParrot,
    norwegian_blue_parrot: NorwegianBlueParrot,
  }.freeze

  class Parrot
    def initialize(type, number_of_coconuts, voltage, nailed)
      klass = PARROT_TYPES.fetch(type) { raise "Unexpected type: #{type}" }
      @delegate = klass.new(coconuts: number_of_coconuts, voltage: voltage)
      @nailed = nailed
    end

    def speed
      return 0 if @nailed
      @delegate.base_speed.clamp(0, 24)
    end
  end
end
