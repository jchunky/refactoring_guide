module ParrotKata
  # Declarative speed rules: type => base_speed_lambda
  SPEED_RULES = {
    european_parrot: ->(_coconuts, _voltage) { 12 },
    african_parrot: ->(coconuts, _voltage) { 12 - (9 * coconuts) },
    norwegian_blue_parrot: ->(_coconuts, voltage) { voltage * 12 },
  }.freeze

  class Parrot < Data.define(:type, :number_of_coconuts, :voltage, :nailed)
    def speed
      return 0 if nailed

      rule = SPEED_RULES.fetch(type) { raise "Unexpected type: #{type}" }
      rule.call(number_of_coconuts, voltage).clamp(0, 24)
    end
  end
end
