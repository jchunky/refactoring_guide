class Bottles
  def verse(number)
    "#{bottle_count(number)} of beer on the wall, " \
    "#{bottle_count(number)} of beer.\n" \
    "#{action(number)}, " \
    "#{bottle_count(number - 1)} of beer on the wall.\n"
  end

  def verses(start, finish)
    start.downto(finish).map { |num| verse(num) }.join("\n")
  end

  def song
    verses(99, 0)
  end

  private

  def bottle_count(number)
    "#{number} bottles"
  end

  def action(number)
    "Take one down and pass it around"
  end
end
