# Refactored using 99 Bottles of OOP principles:
# - Replace conditionals with polymorphism
# - Extract class for each parrot type
# - Open/Closed principle via factory method
# - Each parrot type knows its own speed behavior

class Parrot
  def self.create(type:, number_of_coconuts: 0, voltage: 0, nailed: false)
    case type
    when :european_parrot
      EuropeanParrot.new
    when :african_parrot
      AfricanParrot.new(number_of_coconuts)
    when :norwegian_blue_parrot
      NorwegianBlueParrot.new(voltage, nailed)
    else
      raise "Unknown parrot type: #{type}"
    end
  end

  def initialize(type = nil, number_of_coconuts = 0, voltage = 0, nailed = false)
    # Legacy constructor for backwards compatibility
    if type
      @delegate = Parrot.create(
        type: type,
        number_of_coconuts: number_of_coconuts,
        voltage: voltage,
        nailed: nailed
      )
    end
  end

  def speed
    @delegate ? @delegate.speed : base_speed
  end

  private

  def base_speed
    12.0
  end
end

class EuropeanParrot < Parrot
  def initialize
    # No parameters needed
  end

  def speed
    base_speed
  end
end

class AfricanParrot < Parrot
  LOAD_FACTOR = 9.0

  def initialize(number_of_coconuts)
    @number_of_coconuts = number_of_coconuts
  end

  def speed
    [0, base_speed - load_factor * @number_of_coconuts].max
  end

  private

  def load_factor
    LOAD_FACTOR
  end
end

class NorwegianBlueParrot < Parrot
  MAX_SPEED = 24.0

  def initialize(voltage, nailed)
    @voltage = voltage
    @nailed = nailed
  end

  def speed
    nailed? ? 0 : compute_speed_for_voltage
  end

  private

  def nailed?
    @nailed
  end

  def compute_speed_for_voltage
    [MAX_SPEED, @voltage * base_speed].min
  end
end
