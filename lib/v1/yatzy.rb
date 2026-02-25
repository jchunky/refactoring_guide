# frozen_string_literal: true

module YatzyKata
  class Yatzy
    def self.chance(d1, d2, d3, d4, d5)
      d1 + d2 + d3 + d4 + d5
    end

    def self.yatzy(dice)
      dice.uniq.size == 1 ? 50 : 0
    end

    def self.ones(d1, d2, d3, d4, d5)
      count_value([d1, d2, d3, d4, d5], 1)
    end

    def self.twos(d1, d2, d3, d4, d5)
      count_value([d1, d2, d3, d4, d5], 2)
    end

    def self.threes(d1, d2, d3, d4, d5)
      count_value([d1, d2, d3, d4, d5], 3)
    end

    def self.score_pair(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      6.downto(1) do |i|
        return i * 2 if tallies[i - 1] >= 2
      end
      0
    end

    def self.two_pair(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      pairs = (1..6).select { |i| tallies[i - 1] >= 2 }
      pairs.size == 2 ? pairs.sum * 2 : 0
    end

    def self.three_of_a_kind(d1, d2, d3, d4, d5)
      n_of_a_kind([d1, d2, d3, d4, d5], 3)
    end

    def self.four_of_a_kind(d1, d2, d3, d4, d5)
      n_of_a_kind([d1, d2, d3, d4, d5], 4)
    end

    def self.small_straight(d1, d2, d3, d4, d5)
      [d1, d2, d3, d4, d5].sort == [1, 2, 3, 4, 5] ? 15 : 0
    end

    def self.large_straight(d1, d2, d3, d4, d5)
      [d1, d2, d3, d4, d5].sort == [2, 3, 4, 5, 6] ? 20 : 0
    end

    def self.full_house(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      has_two = (1..6).find { |i| tallies[i - 1] == 2 }
      has_three = (1..6).find { |i| tallies[i - 1] == 3 }

      has_two && has_three ? (has_two * 2) + (has_three * 3) : 0
    end

    def self.count_value(dice, target)
      dice.count(target) * target
    end

    def self.tally(dice)
      tallies = [0] * 6
      dice.each { |d| tallies[d - 1] += 1 }
      tallies
    end

    def self.n_of_a_kind(dice, n)
      tallies = tally(dice)
      (1..6).each do |i|
        return i * n if tallies[i - 1] >= n
      end
      0
    end

    def initialize(d1, d2, d3, d4, d5)
      @dice = [d1, d2, d3, d4, d5]
    end

    # Scoring methods that operate on individual dice args

    # Instance methods for fours, fives, sixes

    def fours
      count_value(4)
    end

    def fives
      count_value(5)
    end

    def sixes
      count_value(6)
    end

    private

    def count_value(target)
      @dice.count(target) * target
    end
  end
end
