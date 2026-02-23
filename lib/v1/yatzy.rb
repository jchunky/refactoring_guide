# frozen_string_literal: true

module YatzyKata
  class Yatzy < Struct.new(:dice)
    def self.method_missing(method, *) = Yatzy.new(*).send(method)

    def initialize(*dice) = super(dice.flatten)

    def chance = dice.sum
    def ones = sum_of(1)
    def twos = sum_of(2)
    def threes = sum_of(3)
    def fours = sum_of(4)
    def fives = sum_of(5)
    def sixes = sum_of(6)
    def yatzy = dice.uniq.one? ? 50 : 0
    def score_pair = highest_n_of_a_kind(2)
    def three_of_a_kind = highest_n_of_a_kind(3)
    def four_of_a_kind = highest_n_of_a_kind(4)
    def small_straight = score_straight(1..5)
    def large_straight = score_straight(2..6)
    def two_pair = pairs.size >= 2 ? pairs.sum * 2 : 0
    def full_house = dice.tally.values.sort == [2, 3] ? dice.sum : 0

    private

    def sum_of(face) = dice.count(face) * face
    def score_straight(range) = dice.sort == range.to_a ? dice.sum : 0
    def pairs = faces_with_at_least(dice, 2)
    def highest_n_of_a_kind(n) = faces_with_at_least(dice, n).max.to_i * n
    def faces_with_at_least(dice, n) = dice.uniq.select { dice.count(it) >= 2 }
  end
end
