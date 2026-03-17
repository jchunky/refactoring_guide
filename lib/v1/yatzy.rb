module YatzyKata
  class Yatzy
    def initialize(d1, d2, d3, d4, d5)
      @dice = [d1, d2, d3, d4, d5]
    end

    def self.chance(d1, d2, d3, d4, d5)
      d1 + d2 + d3 + d4 + d5
    end

    def self.yatzy(dice)
      tallies = tally(dice)
      tallies.any? { |count| count == 5 } ? 50 : 0
    end

    def self.ones(d1, d2, d3, d4, d5)
      sum_of_value([d1, d2, d3, d4, d5], 1)
    end

    def self.twos(d1, d2, d3, d4, d5)
      sum_of_value([d1, d2, d3, d4, d5], 2)
    end

    def self.threes(d1, d2, d3, d4, d5)
      sum_of_value([d1, d2, d3, d4, d5], 3)
    end

    def fours
      self.class.sum_of_value(@dice, 4)
    end

    def fives
      self.class.sum_of_value(@dice, 5)
    end

    def sixes
      self.class.sum_of_value(@dice, 6)
    end

    def self.score_pair(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      5.downto(0) do |i|
        return (i + 1) * 2 if tallies[i] >= 2
      end
      0
    end

    def self.two_pair(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      pairs = []
      tallies.each_with_index do |count, i|
        pairs << (i + 1) if count >= 2
      end
      pairs.size == 2 ? pairs.sum * 2 : 0
    end

    def self.three_of_a_kind(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      tallies.each_with_index do |count, i|
        return (i + 1) * 3 if count >= 3
      end
      0
    end

    def self.four_of_a_kind(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      tallies.each_with_index do |count, i|
        return (i + 1) * 4 if count >= 4
      end
      0
    end

    def self.small_straight(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      tallies[0, 5] == [1, 1, 1, 1, 1] ? 15 : 0
    end

    def self.large_straight(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      tallies[1, 5] == [1, 1, 1, 1, 1] ? 20 : 0
    end

    def self.full_house(d1, d2, d3, d4, d5)
      tallies = tally([d1, d2, d3, d4, d5])
      pair_value = nil
      three_value = nil

      tallies.each_with_index do |count, i|
        pair_value = i + 1 if count == 2
        three_value = i + 1 if count == 3
      end

      pair_value && three_value ? pair_value * 2 + three_value * 3 : 0
    end

    private

    def self.tally(dice)
      tallies = [0] * 6
      dice.each { |die| tallies[die - 1] += 1 }
      tallies
    end

    def self.sum_of_value(dice, value)
      dice.count(value) * value
    end
  end
end
