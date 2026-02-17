module ParrotKata
  class Parrot < Data.define(:type, :number_of_coconuts, :voltage, :nailed)
    def speed
      case [nailed, type]
      in [true, _] then 0
      in [false, :european_parrot] then 12
      in [false, :african_parrot] then (12 - (9 * number_of_coconuts)).clamp(0, 24)
      in [false, :norwegian_blue_parrot] then (voltage * 12).clamp(0, 24)
      else raise "Unexpected type: #{type}"
      end
    end
  end
end
