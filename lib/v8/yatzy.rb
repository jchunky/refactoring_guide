# Refactored to fix:
# - Long Parameter Lists: DiceRoll class encapsulates the 5 dice
# - Data Clumps: Dice values always travel together
# - Primitive Obsession: DiceRoll handles counting and filtering

class DiceRoll
  attr_reader :dice

  def initialize(*dice)
    @dice = dice.flatten.first(5)
  end

  def sum
    @dice.sum
  end

  def count(value)
    @dice.count(value)
  end

  def sum_of(value)
    count(value) * value
  end

  def tallies
    counts = Array.new(6, 0)
    @dice.each { |d| counts[d - 1] += 1 }
    counts
  end

  def has_n_of_a_kind?(n)
    tallies.any? { |count| count >= n }
  end

  def value_with_n_of_a_kind(n)
    tallies.each_with_index do |count, index|
      return index + 1 if count >= n
    end
    nil
  end

  def highest_value_with_n_of_a_kind(n)
    tallies.each_with_index.reverse_each do |count, index|
      return index + 1 if count >= n
    end
    nil
  end

  def pairs
    tallies.each_with_index.select { |count, _| count >= 2 }.map { |_, idx| idx + 1 }
  end

  def small_straight?
    tallies == [1, 1, 1, 1, 1, 0]
  end

  def large_straight?
    tallies == [0, 1, 1, 1, 1, 1]
  end
end

class Yatzy
  def self.chance(*dice)
    DiceRoll.new(dice).sum
  end

  def self.yatzy(dice)
    roll = DiceRoll.new(dice)
    roll.has_n_of_a_kind?(5) ? 50 : 0
  end

  def self.ones(*dice)
    DiceRoll.new(dice).sum_of(1)
  end

  def self.twos(*dice)
    DiceRoll.new(dice).sum_of(2)
  end

  def self.threes(*dice)
    DiceRoll.new(dice).sum_of(3)
  end

  def self.score_pair(*dice)
    roll = DiceRoll.new(dice)
    value = roll.highest_value_with_n_of_a_kind(2)
    value ? value * 2 : 0
  end

  def self.two_pair(*dice)
    roll = DiceRoll.new(dice)
    pairs = roll.pairs
    pairs.size == 2 ? pairs.sum * 2 : 0
  end

  def self.three_of_a_kind(*dice)
    roll = DiceRoll.new(dice)
    value = roll.value_with_n_of_a_kind(3)
    value ? value * 3 : 0
  end

  def self.four_of_a_kind(*dice)
    roll = DiceRoll.new(dice)
    value = roll.value_with_n_of_a_kind(4)
    value ? value * 4 : 0
  end

  def self.small_straight(*dice)
    DiceRoll.new(dice).small_straight? ? 15 : 0
  end

  def self.large_straight(*dice)
    DiceRoll.new(dice).large_straight? ? 20 : 0
  end

  def self.full_house(*dice)
    roll = DiceRoll.new(dice)
    tallies = roll.tallies
    
    pair_value = nil
    three_value = nil
    
    tallies.each_with_index do |count, index|
      pair_value = index + 1 if count == 2
      three_value = index + 1 if count == 3
    end

    pair_value && three_value ? pair_value * 2 + three_value * 3 : 0
  end

  def initialize(d1, d2, d3, d4, d5)
    @roll = DiceRoll.new(d1, d2, d3, d4, d5)
  end

  def fours
    @roll.sum_of(4)
  end

  def fives
    @roll.sum_of(5)
  end

  def sixes
    @roll.sum_of(6)
  end
end
