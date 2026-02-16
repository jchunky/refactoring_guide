class Parrot < Struct.new(:type, :number_of_coconuts, :voltage, :nailed)
  def speed
    return 0 if nailed

    base_speed.clamp(0, 24)
  end

  private

  def base_speed
    case type
    when :european_parrot then 12
    when :african_parrot then 12 - (9 * number_of_coconuts)
    when :norwegian_blue_parrot then voltage * 12
    else raise "Unexpected type: #{type}"
    end
  end
end
