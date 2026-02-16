module ParrotKata
  # Polymorphic parrot classes - replacing case statement with polymorphism
  class Parrot
    PARROT_TYPES = {
      european_parrot: :EuropeanParrot,
      african_parrot: :AfricanParrot,
      norwegian_blue_parrot: :NorwegianBlueParrot
    }.freeze

    def initialize(type, number_of_coconuts = 0, voltage = 0, nailed = false)
      @type = type
      @number_of_coconuts = number_of_coconuts
      @voltage = voltage
      @nailed = nailed
    end

    def speed
      parrot_instance.speed
    end

    private

    def parrot_instance
      klass = Object.const_get(PARROT_TYPES.fetch(@type))
      klass.new(@number_of_coconuts, @voltage, @nailed)
    end

    def base_speed = 12.0
  end

  class EuropeanParrot
    def initialize(number_of_coconuts, voltage, nailed)
    end

    def speed = base_speed
    def base_speed = 12.0
  end

  class AfricanParrot
    def initialize(number_of_coconuts, voltage, nailed)
      @number_of_coconuts = number_of_coconuts
    end

    def speed
      [0, base_speed - load_factor * @number_of_coconuts].max
    end

    def base_speed = 12.0
    def load_factor = 9.0
  end

  class NorwegianBlueParrot
    def initialize(number_of_coconuts, voltage, nailed)
      @voltage = voltage
      @nailed = nailed
    end

    def speed
      return 0 if @nailed
      compute_base_speed_for_voltage
    end

    def base_speed = 12.0

    def compute_base_speed_for_voltage
      [24.0, @voltage * base_speed].min
    end
  end
end
