module YatzyKata
  class Yatzy
    def initialize(d1, d2, d3, d4, d5)
      @dice = [d1, d2, d3, d4, d5]
    end

    def self.chance(d1, d2, d3, d4, d5) = [d1, d2, d3, d4, d5].sum

    def self.yatzy(dice) = dice.tally.any? { it.last == 5 } ? 50 : 0

    def self.ones(d1, d2, d3, d4, d5) = count_value([d1, d2, d3, d4, d5], 1)
    def self.twos(d1, d2, d3, d4, d5) = count_value([d1, d2, d3, d4, d5], 2)
    def self.threes(d1, d2, d3, d4, d5) = count_value([d1, d2, d3, d4, d5], 3)

    def fours = count_value(@dice, 4)
    def fives = count_value(@dice, 5)
    def sixes = count_value(@dice, 6)

    def self.score_pair(d1, d2, d3, d4, d5)
      [d1, d2, d3, d4, d5].tally.select { |_, v| v >= 2 }.keys.max&.*(2) || 0
    end

    def self.two_pair(d1, d2, d3, d4, d5)
      pairs = [d1, d2, d3, d4, d5].tally.select { |_, v| v >= 2 }.keys
      pairs.size == 2 ? pairs.sum * 2 : 0
    end

    def self.three_of_a_kind(d1, d2, d3, d4, d5) = n_of_a_kind([d1, d2, d3, d4, d5], 3)
    def self.four_of_a_kind(d1, d2, d3, d4, d5) = n_of_a_kind([d1, d2, d3, d4, d5], 4)

    def self.small_straight(d1, d2, d3, d4, d5)
      [d1, d2, d3, d4, d5].sort == [1, 2, 3, 4, 5] ? 15 : 0
    end

    def self.large_straight(d1, d2, d3, d4, d5)
      [d1, d2, d3, d4, d5].sort == [2, 3, 4, 5, 6] ? 20 : 0
    end

    def self.full_house(d1, d2, d3, d4, d5)
      tallies = [d1, d2, d3, d4, d5].tally
      tallies.values.sort == [2, 3] ? tallies.sum { it.first * it.last } : 0
    end

    private

    def self.count_value(dice, value) = dice.count(value) * value
    def count_value(dice, value) = self.class.count_value(dice, value)

    def self.n_of_a_kind(dice, n)
      dice.tally.detect { it.last >= n }&.then { it.first * n } || 0
    end
  end
end
