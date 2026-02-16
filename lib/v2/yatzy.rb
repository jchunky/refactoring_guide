module YatzyKata
  class Yatzy < Struct.new(:dice)
    def self.method_missing(method, *) = new(*).send(method)

    def initialize(*dice) = super(dice.flatten)

    def chance = dice.sum
    def ones = dice.count(1) * 1
    def twos = dice.count(2) * 2
    def threes = dice.count(3) * 3
    def fours = dice.count(4) * 4
    def fives = dice.count(5) * 5
    def sixes = dice.count(6) * 6
    def yatzy = dice.uniq.one? ? 50 : 0
    def score_pair = score_n_of_a_kind(2)
    def three_of_a_kind = score_n_of_a_kind(3)
    def four_of_a_kind = score_n_of_a_kind(4)
    def two_pair = pairs.count == 2 ? pairs.sum * 2 : 0
    def small_straight = dice.sort == (1..5).to_a ? dice.sum : 0
    def large_straight = dice.sort == (2..6).to_a ? dice.sum : 0
    def full_house = dice.tally.values.sort == [2, 3] ? dice.sum : 0

    private

    def score_n_of_a_kind(n) = dice.uniq.select { dice.count(it) >= n }.max.to_i * n
    def pairs = dice.uniq.select { dice.count(it) >= 2 }
  end
end
