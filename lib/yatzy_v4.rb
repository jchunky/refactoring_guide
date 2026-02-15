class Yatzy
  def initialize(*dice)
    @dice = dice.flatten
  end

  def self.chance(*dice)
    dice.sum
  end

  def self.yatzy(dice)
    dice.uniq.size == 1 ? 50 : 0
  end

  def self.ones(*dice)
    score_for(dice, 1)
  end

  def self.twos(*dice)
    score_for(dice, 2)
  end

  def self.threes(*dice)
    score_for(dice, 3)
  end

  def fours
    self.class.score_for(@dice, 4)
  end

  def fives
    self.class.score_for(@dice, 5)
  end

  def sixes
    self.class.score_for(@dice, 6)
  end

  def self.score_pair(*dice)
    find_of_a_kind(dice, 2)
  end

  def self.two_pair(*dice)
    pairs = dice.tally.select { |_, count| count >= 2 }.keys
    pairs.size == 2 ? pairs.sum * 2 : 0
  end

  def self.three_of_a_kind(*dice)
    find_of_a_kind(dice, 3)
  end

  def self.four_of_a_kind(*dice)
    find_of_a_kind(dice, 4)
  end

  def self.small_straight(*dice)
    dice.sort == [1, 2, 3, 4, 5] ? 15 : 0
  end

  def self.large_straight(*dice)
    dice.sort == [2, 3, 4, 5, 6] ? 20 : 0
  end

  def self.full_house(*dice)
    counts = dice.tally.values.sort
    counts == [2, 3] ? dice.sum : 0
  end

  private

  def self.score_for(dice, value)
    dice.count(value) * value
  end

  def self.find_of_a_kind(dice, count)
    match = dice.tally.select { |_, c| c >= count }.keys.max
    match ? match * count : 0
  end
end
