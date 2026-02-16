# Refactored to fix Feature Envy: Each parrot type calculates its own speed
# Using polymorphism - ask objects to do things, don't reach into them

# Individual parrot type classes encapsulate their own speed calculation
class EuropeanParrot
  BASE_SPEED = 12.0

  def speed
    BASE_SPEED
  end
end

class AfricanParrot
  BASE_SPEED = 12.0
  LOAD_FACTOR = 9.0

  def initialize(number_of_coconuts)
    @number_of_coconuts = number_of_coconuts
  end

  def speed
    [0, BASE_SPEED - LOAD_FACTOR * @number_of_coconuts].max
  end
end

class NorwegianBlueParrot
  BASE_SPEED = 12.0
  MAX_SPEED = 24.0

  def initialize(voltage:, nailed:)
    @voltage = voltage
    @nailed = nailed
  end

  def speed
    @nailed ? 0 : compute_base_speed_for_voltage
  end

  private

  def compute_base_speed_for_voltage
    [MAX_SPEED, @voltage * BASE_SPEED].min
  end
end

# Main Parrot class maintains original interface but delegates to type-specific classes
# This eliminates Feature Envy by having each parrot type calculate its own speed
class Parrot
  def initialize(type, number_of_coconuts, voltage, nailed)
    @delegate = create_delegate(type, number_of_coconuts, voltage, nailed)
  end

  def speed
    @delegate.speed
  end

  private

  def create_delegate(type, number_of_coconuts, voltage, nailed)
    case type
    when :european_parrot
      EuropeanParrot.new
    when :african_parrot
      AfricanParrot.new(number_of_coconuts)
    when :norwegian_blue_parrot
      NorwegianBlueParrot.new(voltage: voltage, nailed: nailed)
    else
      raise "Unknown parrot type: #{type}"
    end
  end
end
