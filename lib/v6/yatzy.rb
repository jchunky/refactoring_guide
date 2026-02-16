module YatzyKata
  class Yatzy
    def initialize(d1, d2, d3, d4, d5)
      @dice = [d1, d2, d3, d4, d5]
    end

    def self.chance(d1, d2, d3, d4, d5)
      [d1, d2, d3, d4, d5].sum
    end

    def self.yatzy(dice)
      return 50 if dice.uniq.length == 1
      0
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

    def fours
      self.class.count_value(@dice, 4)
    end

    def fives
      self.class.count_value(@dice, 5)
    end

    def sixes
      self.class.count_value(@dice, 6)
    end

    def self.count_value(dice, value)
      dice.count(value) * value
    end

    def self.score_pair(d1, d2, d3, d4, d5)
      find_of_a_kind([d1, d2, d3, d4, d5], 2) * 2
    end

    def self.two_pair(d1, d2, d3, d4, d5)
      pairs = find_all_pairs([d1, d2, d3, d4, d5])
      return 0 unless pairs.length == 2
      pairs.sum * 2
    end

    def self.three_of_a_kind(d1, d2, d3, d4, d5)
      find_of_a_kind([d1, d2, d3, d4, d5], 3) * 3
    end

    def self.four_of_a_kind(d1, d2, d3, d4, d5)
      find_of_a_kind([d1, d2, d3, d4, d5], 4) * 4
    end

    def self.small_straight(d1, d2, d3, d4, d5)
      return 15 if [d1, d2, d3, d4, d5].sort == [1, 2, 3, 4, 5]
      0
    end

    def self.large_straight(d1, d2, d3, d4, d5)
      return 20 if [d1, d2, d3, d4, d5].sort == [2, 3, 4, 5, 6]
      0
    end

    def self.full_house(d1, d2, d3, d4, d5)
      dice = [d1, d2, d3, d4, d5]
      pair_value = find_exact_count(dice, 2)
      three_value = find_exact_count(dice, 3)
      return 0 unless pair_value && three_value
      pair_value * 2 + three_value * 3
    end

    def self.tallies(dice)
      dice.each_with_object(Hash.new(0)) { |d, h| h[d] += 1 }
    end

    def self.find_of_a_kind(dice, count)
      tallies(dice).select { |_, v| v >= count }.keys.max || 0
    end

    def self.find_exact_count(dice, count)
      tallies(dice).find { |_, v| v == count }&.first
    end

    def self.find_all_pairs(dice)
      tallies(dice).select { |_, v| v >= 2 }.keys
    end
  end
end
