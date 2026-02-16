class Parrot
  BASE_SPEED = 12.0
  MAX_SPEED = 24.0
  LOAD_FACTOR = 9.0

  def initialize(type, number_of_coconuts, voltage, nailed)
    @type = type
    @number_of_coconuts = number_of_coconuts
    @voltage = voltage
    @nailed = nailed
  end

  def speed
    case @type
    when :european_parrot
      european_speed
    when :african_parrot
      african_speed
    when :norwegian_blue_parrot
      norwegian_blue_speed
    else
      raise "Unknown parrot type: #{@type}"
    end
  end

  private

  def european_speed
    BASE_SPEED
  end

  def african_speed
    [0, BASE_SPEED - coconut_load].max
  end

  def norwegian_blue_speed
    @nailed ? 0 : voltage_speed
  end

  def coconut_load
    LOAD_FACTOR * @number_of_coconuts
  end

  def voltage_speed
    [MAX_SPEED, @voltage * BASE_SPEED].min
  end
end
