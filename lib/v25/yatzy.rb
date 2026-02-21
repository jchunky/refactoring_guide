# frozen_string_literal: true

module YatzyKata
  class Yatzy
    def self.chance(d1, d2, d3, d4, d5)
      total = 0
      total += d1
      total += d2
      total += d3
      total += d4
      total += d5
      total
    end

    def self.yatzy(dice)
      counts = [0] * (dice.length + 1)
      dice.each do |die|
        counts[die - 1] += 1
      end
      (0..counts.size).each do |i|
        if counts[i] == 5
          return 50
        end
      end
      0
    end

    def self.ones(d1, d2, d3, d4, d5)
      sum = 0
      if d1 == 1
        sum += 1
      end
      if d2 == 1
        sum += 1
      end
      if d3 == 1
        sum += 1
      end
      if d4 == 1
        sum += 1
      end
      if d5 == 1
        sum += 1
      end

      sum
    end

    def self.twos(d1, d2, d3, d4, d5)
      sum = 0
      if d1 == 2
        sum += 2
      end
      if d2 == 2
        sum += 2
      end
      if d3 == 2
        sum += 2
      end
      if d4 == 2
        sum += 2
      end
      if d5 == 2
        sum += 2
      end
      sum
    end

    def self.threes(d1, d2, d3, d4, d5)
      s = 0
      if d1 == 3
        s += 3
      end
      if d2 == 3
        s += 3
      end
      if d3 == 3
        s += 3
      end
      if d4 == 3
        s += 3
      end
      if d5 == 3
        s += 3
      end
      s
    end

    def self.score_pair(d1, d2, d3, d4, d5)
      counts = [0] * 6
      counts[d1 - 1] += 1
      counts[d2 - 1] += 1
      counts[d3 - 1] += 1
      counts[d4 - 1] += 1
      counts[d5 - 1] += 1
      at = 0
      (0...6).each do |at|
        if counts[6 - at - 1] >= 2
          return (6 - at) * 2
        end
      end
      0
    end

    def self.two_pair(d1, d2, d3, d4, d5)
      counts = [0] * 6
      counts[d1 - 1] += 1
      counts[d2 - 1] += 1
      counts[d3 - 1] += 1
      counts[d4 - 1] += 1
      counts[d5 - 1] += 1
      n = 0
      score = 0
      Array(0..5).each do |i|
        if counts[6 - i - 1] >= 2
          n += 1
          score += (6 - i)
        end
      end
      if n == 2
        score * 2
      else
        0
      end
    end

    def self.four_of_a_kind(_d1, _d2, d3, d4, d5)
      tallies = [0] * 6
      tallies[_d1 - 1] += 1
      tallies[_d2 - 1] += 1
      tallies[d3 - 1] += 1
      tallies[d4 - 1] += 1
      tallies[d5 - 1] += 1
      (0..6).each do |i|
        if tallies[i] >= 4
          return (i + 1) * 4
        end
      end
      0
    end

    def self.three_of_a_kind(d1, d2, d3, d4, d5)
      t = [0] * 6
      t[d1 - 1] += 1
      t[d2 - 1] += 1
      t[d3 - 1] += 1
      t[d4 - 1] += 1
      t[d5 - 1] += 1
      [0, 1, 2, 3, 4, 5].each do |i|
        if t[i] >= 3
          return (i + 1) * 3
        end
      end
      0
    end

    def self.small_straight(d1, d2, d3, d4, d5)
      tallies = [0] * 6
      tallies[d1 - 1] += 1
      tallies[d2 - 1] += 1
      tallies[d3 - 1] += 1
      tallies[d4 - 1] += 1
      tallies[d5 - 1] += 1
      if (tallies[0] == 1) &&
         (tallies[1] == 1) &&
         (tallies[2] == 1) &&
         (tallies[3] == 1) &&
         (tallies[4] == 1)
        15
      else
        0
      end
    end

    def self.large_straight(d1, d2, d3, d4, d5)
      tallies = [0] * 6
      tallies[d1 - 1] += 1
      tallies[d2 - 1] += 1
      tallies[d3 - 1] += 1
      tallies[d4 - 1] += 1
      tallies[d5 - 1] += 1
      if (tallies[1] == 1) && (tallies[2] == 1) && (tallies[3] == 1) && (tallies[4] == 1) && (tallies[5] == 1)
        return 20
      end

      0
    end

    def self.full_house(d1, d2, d3, d4, d5)
      tallies = []
      _d2 = false
      i = 0
      _d2_at = 0
      _d3 = false
      _d3_at = 0

      tallies = [0] * 6
      tallies[d1 - 1] += 1
      tallies[d2 - 1] += 1
      tallies[d3 - 1] += 1
      tallies[d4 - 1] += 1
      tallies[d5 - 1] += 1

      Array(0..5).each do |i|
        if tallies[i] == 2
          _d2 = true
          _d2_at = i + 1
        end
      end

      Array(0..5).each do |i|
        if tallies[i] == 3
          _d3 = true
          _d3_at = i + 1
        end
      end

      if _d2 && _d3
        (_d2_at * 2) + (_d3_at * 3)
      else
        0
      end
    end

    def initialize(d1, d2, d3, d4, _d5)
      @dice = [0] * 5
      @dice[0] = d1
      @dice[1] = d2
      @dice[2] = d3
      @dice[3] = d4
      @dice[4] = _d5
    end

    def fours
      sum = 0
      Array(0..4).each do |at|
        if @dice[at] == 4
          sum += 4
        end
      end
      sum
    end

    def fives
      s = 0
      i = 0
      Range.new(0, @dice.size).each do |i|
        if @dice[i] == 5
          s += 5
        end
      end
      s
    end

    def sixes
      sum = 0
      (0..@dice.length).each do |at|
        if @dice[at] == 6
          sum += 6
        end
      end
      sum
    end
  end
end
