module ParrotKata
  module SpeedPipeline
    def self.base_speed(type, coconuts, voltage)
      case type
      in :european_parrot then 12
      in :african_parrot then 12 - (9 * coconuts)
      in :norwegian_blue_parrot then voltage * 12
      else raise "Unexpected type: #{type}"
      end
    end

    def self.compute(type, coconuts, voltage, nailed)
      nailed
        .then { it ? 0 : base_speed(type, coconuts, voltage) }
        .then { it.clamp(0, 24) }
    end
  end

  class Parrot < Data.define(:type, :number_of_coconuts, :voltage, :nailed)
    def speed = SpeedPipeline.compute(type, number_of_coconuts, voltage, nailed)
  end
end
