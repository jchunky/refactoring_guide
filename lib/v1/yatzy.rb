# frozen_string_literal: true

module YatzyKata
  class Yatzy < Struct.new(:dice)
    def self.method_missing(method, *) = new(*).send(method)

    def initialize(*dice) = super(dice.flatten)

    def chance = dice.sum
    def ones = score_face(1)
    def twos = score_face(2)
    def threes = score_face(3)
    def fours = score_face(4)
    def fives = score_face(5)
    def sixes = score_face(6)
    def yatzy = dice.uniq.one? ? 50 : 0
    def score_pair = score_n_of_a_kind(2)
    def three_of_a_kind = score_n_of_a_kind(3)
    def four_of_a_kind = score_n_of_a_kind(4)
    def small_straight = score_straight(1..5)
    def large_straight = score_straight(2..6)
    def two_pair = pairs.count == 2 ? pairs.sum * 2 : 0
    def full_house = dice.tally.values.sort == [2, 3] ? dice.sum : 0

    private

    def pairs = find_n_of_a_kind(2)
    def score_face(face) = dice.count(face) * face
    def score_n_of_a_kind(n) = find_n_of_a_kind(n).max.to_i * n
    def score_straight(range) = dice.sort == range.to_a ? dice.sum : 0
    def find_n_of_a_kind(n) = dice.uniq.select { dice.count(it) >= n }
  end
end
