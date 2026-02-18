module YatzyKata
  class Yatzy
    def self.chance(d1, d2, d3, d4, d5)
      [d1, d2, d3, d4, d5].sum
    end

    def self.yatzy(dice)
      counts = tally(dice)
      counts.any? { |count| count == 5 } ? 50 : 0
    end

    def self.ones( d1,  d2,  d3,  d4,  d5)
      sum_of(1, [d1, d2, d3, d4, d5])
    end

    def self.twos( d1,  d2,  d3,  d4,  d5)
      sum_of(2, [d1, d2, d3, d4, d5])
    end

    def self.threes( d1,  d2,  d3,  d4,  d5)
      sum_of(3, [d1, d2, d3, d4, d5])
    end

    def initialize(d1, d2, d3, d4, _d5)
      @dice = [d1, d2, d3, d4, _d5]
    end

    def fours
      sum_of(4, @dice)
    end

    def fives()
      sum_of(5, @dice)
    end

    def sixes
      sum_of(6, @dice)
    end

    def self.score_pair( d1,  d2,  d3,  d4,  d5)
      counts = tally([d1, d2, d3, d4, d5])
      highest = highest_of_a_kind(counts, 2)
      highest ? highest * 2 : 0
    end

    def self.two_pair( d1,  d2,  d3,  d4,  d5)
      counts = tally([d1, d2, d3, d4, d5])
      pairs = counts.each_with_index.select { |count, _idx| count >= 2 }.map { |_count, idx| idx + 1 }
      return 0 unless pairs.size == 2

      pairs.sum * 2
    end

    def self.four_of_a_kind( _d1,  _d2,  d3,  d4,  d5)
      counts = tally([_d1, _d2, d3, d4, d5])
      highest = highest_of_a_kind(counts, 4)
      highest ? highest * 4 : 0
    end

    def self.three_of_a_kind( d1,  d2,  d3,  d4,  d5)
      counts = tally([d1, d2, d3, d4, d5])
      highest = highest_of_a_kind(counts, 3)
      highest ? highest * 3 : 0
    end

    def self.small_straight( d1,  d2,  d3,  d4,  d5)
      counts = tally([d1, d2, d3, d4, d5])
      counts[0, 5].all? { |count| count == 1 } ? 15 : 0
    end

    def self.large_straight( d1,  d2,  d3,  d4,  d5)
      counts = tally([d1, d2, d3, d4, d5])
      counts[1, 5].all? { |count| count == 1 } ? 20 : 0
    end

    def self.full_house( d1,  d2,  d3,  d4,  d5)
      counts = tally([d1, d2, d3, d4, d5])
      pair_value = counts.index(2)
      triple_value = counts.index(3)
      return 0 unless pair_value && triple_value

      (pair_value + 1) * 2 + (triple_value + 1) * 3
    end

    def self.tally(dice)
      counts = Array.new(6, 0)
      dice.each { |die| counts[die - 1] += 1 }
      counts
    end

    def self.highest_of_a_kind(counts, target)
      counts.each_with_index.reverse_each do |count, index|
        return index + 1 if count >= target
      end
      nil
    end

    def self.sum_of(value, dice)
      dice.count(value) * value
    end

    def sum_of(value, dice)
      self.class.sum_of(value, dice)
    end
  end
end
