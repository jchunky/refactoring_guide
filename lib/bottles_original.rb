class Bottles
  def verse(number)
    "#{number} bottles of beer on the wall, " +
    "#{number} bottles of beer.\n" +
    "Take one down and pass it around, " +
    "#{number - 1} bottles of beer on the wall.\n"
  end

  def verses(start, finish)
    result = []
    start.downto(finish) do |num|
      result << verse(num)
    end
    result.join("\n")
  end

  def song
    verses(99, 0)
  end
end
