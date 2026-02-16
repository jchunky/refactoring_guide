class Yatzy
  YATZY_SCORE = 50
  SMALL_STRAIGHT_SCORE = 15
  LARGE_STRAIGHT_SCORE = 20

  def self.chance(*dice)
    dice.sum
  end

  def self.yatzy(dice)
    all_same?(dice) ? YATZY_SCORE : 0
  end

  def self.ones(*dice)
    sum_of_value(dice, 1)
  end

  def self.twos(*dice)
    sum_of_value(dice, 2)
  end

  def self.threes(*dice)
    sum_of_value(dice, 3)
  end

  def self.score_pair(*dice)
    find_n_of_a_kind(dice, 2) * 2
  end

  def self.two_pair(*dice)
    pairs = find_all_pairs(dice)
    pairs.size == 2 ? pairs.sum * 2 : 0
  end

  def self.three_of_a_kind(*dice)
    find_n_of_a_kind(dice, 3) * 3
  end

  def self.four_of_a_kind(*dice)
    find_n_of_a_kind(dice, 4) * 4
  end

  def self.small_straight(*dice)
    sorted = dice.sort
    sorted == [1, 2, 3, 4, 5] ? SMALL_STRAIGHT_SCORE : 0
  end

  def self.large_straight(*dice)
    sorted = dice.sort
    sorted == [2, 3, 4, 5, 6] ? LARGE_STRAIGHT_SCORE : 0
  end

  def self.full_house(*dice)
    counts = count_dice(dice)
    values = counts.values.sort

    if values == [2, 3]
      pair_value = counts.key(2)
      triple_value = counts.key(3)
      pair_value * 2 + triple_value * 3
    else
      0
    end
  end

  # Instance methods for compatibility with original API
  def initialize(*dice)
    @dice = dice
  end

  def fours
    sum_of_value(@dice, 4)
  end

  def fives
    sum_of_value(@dice, 5)
  end

  def sixes
    sum_of_value(@dice, 6)
  end

  private

  def self.all_same?(dice)
    dice.uniq.size == 1
  end

  def self.sum_of_value(dice, value)
    dice.count(value) * value
  end

  def self.count_dice(dice)
    dice.each_with_object(Hash.new(0)) { |die, counts| counts[die] += 1 }
  end

  def self.find_n_of_a_kind(dice, n)
    counts = count_dice(dice)
    matches = counts.select { |_, count| count >= n }
    matches.empty? ? 0 : matches.keys.max
  end

  def self.find_all_pairs(dice)
    counts = count_dice(dice)
    counts.select { |_, count| count >= 2 }.keys
  end

  def sum_of_value(dice, value)
    self.class.sum_of_value(dice, value)
  end
end
