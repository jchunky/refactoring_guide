# frozen_string_literal: true

module YatzyKata
  class Yatzy
    def self.chance(d1, d2, d3, d4, d5) = d1 + d2 + d3 + d4 + d5
    def self.yatzy(dice) = dice.uniq.size == 1 ? 50 : 0
    def self.ones(d1, d2, d3, d4, d5) = sum_of([d1, d2, d3, d4, d5], 1)
    def self.twos(d1, d2, d3, d4, d5) = sum_of([d1, d2, d3, d4, d5], 2)
    def self.threes(d1, d2, d3, d4, d5) = sum_of([d1, d2, d3, d4, d5], 3)

    def self.score_pair(d1, d2, d3, d4, d5)
      highest_n_of_a_kind([d1, d2, d3, d4, d5], 2)
    end

    def self.three_of_a_kind(d1, d2, d3, d4, d5)
      highest_n_of_a_kind([d1, d2, d3, d4, d5], 3)
    end

    def self.four_of_a_kind(d1, d2, d3, d4, d5)
      highest_n_of_a_kind([d1, d2, d3, d4, d5], 4)
    end

    def self.two_pair(d1, d2, d3, d4, d5)
      pairs = faces_with_at_least([d1, d2, d3, d4, d5], 2)
      pairs.size >= 2 ? pairs.sum * 2 : 0
    end

    def self.small_straight(d1, d2, d3, d4, d5)
      [d1, d2, d3, d4, d5].sort == [1, 2, 3, 4, 5] ? 15 : 0
    end

    def self.large_straight(d1, d2, d3, d4, d5)
      [d1, d2, d3, d4, d5].sort == [2, 3, 4, 5, 6] ? 20 : 0
    end

    def self.full_house(d1, d2, d3, d4, d5)
      counts = [d1, d2, d3, d4, d5].tally
      pair_face = counts.find { |_, count| count == 2 }&.first
      triple_face = counts.find { |_, count| count == 3 }&.first
      pair_face && triple_face ? (pair_face * 2) + (triple_face * 3) : 0
    end

    def self.sum_of(dice, face) = dice.count(face) * face

    def self.highest_n_of_a_kind(dice, n)
      face = faces_with_at_least(dice, n).max
      face ? face * n : 0
    end

    def self.faces_with_at_least(dice, n)
      dice.tally.select { |_, count| count >= n }.keys
    end

    def initialize(*dice)
      @dice = dice
    end

    # Scoring methods that take individual dice as arguments

    def fours = @dice.count(4) * 4
    def fives = @dice.count(5) * 5
    def sixes = @dice.count(6) * 6

    # Private helpers

    private_class_method :sum_of, :highest_n_of_a_kind, :faces_with_at_least
  end
end
