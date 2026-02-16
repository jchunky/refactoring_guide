# Parrot Kata
#
# Calculates the speed of different parrot types based on their characteristics.
#
# Parrot types and their speed rules:
# - European Parrot: Always flies at base speed (12.0)
# - African Parrot: Speed reduced by load factor (9.0) per coconut carried
# - Norwegian Blue: Speed based on voltage, but capped at 24.0; nailed parrots cannot move

module ParrotKata
  class Parrot
    # Speed constants
    BASE_SPEED = 12.0
    MAXIMUM_NORWEGIAN_BLUE_SPEED = 24.0
    AFRICAN_PARROT_LOAD_FACTOR = 9.0

    # Parrot types
    PARROT_TYPES = {
      european: :european_parrot,
      african: :african_parrot,
      norwegian_blue: :norwegian_blue_parrot
    }.freeze

    def initialize(parrot_type, number_of_coconuts, voltage, is_nailed)
      @parrot_type = parrot_type
      @number_of_coconuts = number_of_coconuts
      @voltage = voltage
      @is_nailed = is_nailed
    end

    # Calculate the parrot's flying speed based on type and characteristics
    def speed
      case @parrot_type
      when PARROT_TYPES[:european]
        european_parrot_speed
      when PARROT_TYPES[:african]
        african_parrot_speed
      when PARROT_TYPES[:norwegian_blue]
        norwegian_blue_parrot_speed
      else
        raise "Unknown parrot type: #{@parrot_type}"
      end
    end

    private

    # European parrots always fly at base speed
    def european_parrot_speed
      BASE_SPEED
    end

    # African parrots are slowed down by the coconuts they carry
    # Speed = base_speed - (load_factor * number_of_coconuts)
    # Speed cannot go below 0
    def african_parrot_speed
      speed_reduction = AFRICAN_PARROT_LOAD_FACTOR * @number_of_coconuts
      [0, BASE_SPEED - speed_reduction].max
    end

    # Norwegian Blue parrots fly based on voltage
    # - If nailed to perch, they cannot move (speed = 0)
    # - Otherwise, speed = voltage * base_speed, capped at maximum
    def norwegian_blue_parrot_speed
      return 0 if @is_nailed

      voltage_based_speed = @voltage * BASE_SPEED
      [voltage_based_speed, MAXIMUM_NORWEGIAN_BLUE_SPEED].min
    end
  end
end
