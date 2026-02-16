module YatzyKata
  # Refactored using 99 Bottles of OOP principles:
  # - Extract class for DiceRoll concept
  # - Small methods that do one thing
  # - Consistent approach to similar problems
  # - Names reflect roles

  class DiceRoll
    def initialize(*dice)
      @dice = dice.flatten
    end

    def sum
      @dice.sum
    end

    def sum_of(value)
      @dice.count(value) * value
    end

    def counts
      @counts ||= @dice.each_with_object(Hash.new(0)) { |die, hash| hash[die] += 1 }
    end

    def has_n_of_a_kind?(n)
      counts.values.any? { |count| count >= n }
    end

    def value_with_count(n)
      counts.find { |_, count| count >= n }&.first
    end

    def values_with_at_least(n)
      counts.select { |_, count| count >= n }.keys
    end

    def sorted
      @dice.sort
    end
  end

  class Yatzy
    def self.chance(*dice)
      DiceRoll.new(dice).sum
    end

    def self.yatzy(dice)
      DiceRoll.new(dice).has_n_of_a_kind?(5) ? 50 : 0
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
      pairs = roll.values_with_at_least(2)
      pairs.empty? ? 0 : pairs.max * 2
    end

    def self.two_pair(*dice)
      roll = DiceRoll.new(dice)
      pairs = roll.values_with_at_least(2)
      pairs.size >= 2 ? pairs.max(2).sum * 2 : 0
    end

    def self.three_of_a_kind(*dice)
      roll = DiceRoll.new(dice)
      value = roll.value_with_count(3)
      value ? value * 3 : 0
    end

    def self.four_of_a_kind(*dice)
      roll = DiceRoll.new(dice)
      value = roll.value_with_count(4)
      value ? value * 4 : 0
    end

    def self.small_straight(*dice)
      DiceRoll.new(dice).sorted == [1, 2, 3, 4, 5] ? 15 : 0
    end

    def self.large_straight(*dice)
      DiceRoll.new(dice).sorted == [2, 3, 4, 5, 6] ? 20 : 0
    end

    def self.full_house(*dice)
      roll = DiceRoll.new(dice)
      pair_value = nil
      three_value = nil

      roll.counts.each do |value, count|
        pair_value = value if count == 2
        three_value = value if count == 3
      end

      pair_value && three_value ? (pair_value * 2) + (three_value * 3) : 0
    end

    # Instance methods for backwards compatibility
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
end
