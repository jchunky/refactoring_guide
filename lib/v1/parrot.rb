# frozen_string_literal: true

module ParrotKata
  class Parrot < Struct.new(:type, :number_of_coconuts, :voltage, :nailed)
    BASE_SPEED = 12
    MAX_SPEED = 24
    LOAD_FACTOR = 9

    def speed
      return 0 if nailed

      base_speed.clamp(0, MAX_SPEED)
    end

    private

    def base_speed
      case type
      when :european_parrot then BASE_SPEED
      when :african_parrot then BASE_SPEED - (LOAD_FACTOR * number_of_coconuts)
      when :norwegian_blue_parrot then voltage * BASE_SPEED
      else raise "Unknown parrot type: #{type}"
      end
    end
  end
end
