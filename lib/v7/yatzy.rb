class Yatzy
  def initialize(*dice)
    @dice = dice.flatten
  end

  def self.chance(*dice)
    dice.flatten.sum
  end

  def self.yatzy(dice)
    dice.uniq.size == 1 ? 50 : 0
  end

  def self.ones(*dice)   = count_value(dice, 1)
  def self.twos(*dice)   = count_value(dice, 2)
  def self.threes(*dice) = count_value(dice, 3)

  def fours = count_value(@dice, 4)
  def fives = count_value(@dice, 5)
  def sixes = count_value(@dice, 6)

  def self.score_pair(*dice)
    find_of_a_kind(dice.flatten, 2) * 2
  end

  def self.two_pair(*dice)
    pairs = tally(dice.flatten).select { |_, count| count >= 2 }.keys.sort.reverse.take(2)
    pairs.size == 2 ? pairs.sum * 2 : 0
  end

  def self.three_of_a_kind(*dice)
    find_of_a_kind(dice.flatten, 3) * 3
  end

  def self.four_of_a_kind(*dice)
    find_of_a_kind(dice.flatten, 4) * 4
  end

  def self.small_straight(*dice)
    dice.flatten.sort == [1, 2, 3, 4, 5] ? 15 : 0
  end

  def self.large_straight(*dice)
    dice.flatten.sort == [2, 3, 4, 5, 6] ? 20 : 0
  end

  def self.full_house(*dice)
    counts = tally(dice.flatten)
    values = counts.values.sort
    return 0 unless values == [2, 3]
    
    pair = counts.key(2)
    triple = counts.key(3)
    pair * 2 + triple * 3
  end

  private

  def count_value(dice, value)
    dice.flatten.count(value) * value
  end

  def self.count_value(dice, value)
    dice.flatten.count(value) * value
  end

  def self.tally(dice)
    dice.group_by(&:itself).transform_values(&:size)
  end

  def self.find_of_a_kind(dice, count)
    tally(dice).select { |_, c| c >= count }.keys.max || 0
  end
end
