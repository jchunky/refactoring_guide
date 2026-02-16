# Verse handles the logic for a specific bottle count
class Verse < Struct.new(:number)
  ACTIONS = {
    0 => "Go to the store and buy some more",
    1 => "Take it down and pass it around",
  }.tap { |h| h.default = "Take one down and pass it around" }

  def to_s = "#{bottle_count.then { number.zero? ? it.capitalize : it }} of beer on the wall, #{bottle_count} of beer.\n#{action}, #{next_bottle_count} of beer on the wall.\n"

  private

  def bottle_count = "#{quantity} #{container}"

  def quantity
    case number
    in 0 then "no more"
    else number.to_s
    end
  end

  def container
    case number
    in 1 then "bottle"
    else "bottles"
    end
  end

  def action = ACTIONS[number]

  def next_bottle_count
    case number
    in 0 then "99 bottles"
    in 1 then "no more bottles"
    in 2 then "1 bottle"
    else "#{number - 1} bottles"
    end
  end
end

class Bottles
  def verse(number) = Verse.new(number).to_s

  def verses(start, finish) = start.downto(finish).map { verse(it) }.join("\n")

  def song = verses(99, 0)
end
