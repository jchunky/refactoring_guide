# Refactored using Primitive Obsession: BottleNumber class encapsulates bottle-related behavior
class BottleNumber
  attr_reader :number

  def initialize(number)
    @number = number
  end

  def container
    number == 1 ? 'bottle' : 'bottles'
  end

  def quantity
    number == 0 ? 'no more' : number.to_s
  end

  def capitalized_quantity
    number == 0 ? 'No more' : number.to_s
  end

  def action
    number == 0 ? 'Go to the store and buy some more' : 'Take ' + pronoun + ' down and pass it around'
  end

  def pronoun
    number == 1 ? 'it' : 'one'
  end

  def successor
    BottleNumber.new(number == 0 ? 99 : number - 1)
  end

  def to_s
    "#{quantity} #{container}"
  end
end

class Bottles
  def verse(number)
    bottle_number = BottleNumber.new(number)
    next_bottle_number = bottle_number.successor

    "#{bottle_number.capitalized_quantity} #{bottle_number.container} of beer on the wall, " +
    "#{bottle_number} of beer.\n" +
    "#{bottle_number.action}, " +
    "#{next_bottle_number} of beer on the wall.\n"
  end

  def verses(start, finish)
    start.downto(finish).map { |num| verse(num) }.join("\n")
  end

  def song
    verses(99, 0)
  end
end
