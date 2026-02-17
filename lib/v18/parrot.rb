module ParrotKata
  class Parrot < Data.define(:type, :number_of_coconuts, :voltage, :nailed)
    def speed
      return 0 if nailed

      base_speed.clamp(0, 24)
    end

    private

    def base_speed
      case type
      in :european_parrot then 12
      in :african_parrot then 12 - (9 * number_of_coconuts)
      in :norwegian_blue_parrot then voltage * 12
      else raise "Unexpected type: #{type}"
      end
    end
  end
end
