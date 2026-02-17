module YatzyKata
  class Yatzy < Data.define(:dice)
    def self.new(*dice) = super(dice: dice.flatten.freeze)
    def self.method_missing(method, *args) = new(*args).send(method)
    def self.respond_to_missing?(method, include_private = false) = instance_methods.include?(method) || super

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
    def small_straight = score_straight(1..5)
    def large_straight = score_straight(2..6)
    def two_pair = pairs.count == 2 ? pairs.sum * 2 : 0
    def full_house = dice.tally.values.sort == [2, 3] ? dice.sum : 0

    private

    def pairs = find_n_of_a_kind(2)
    def score_n_of_a_kind(n) = find_n_of_a_kind(n).max.to_i * n
    def score_straight(range) = dice.sort == range.to_a ? dice.sum : 0
    def find_n_of_a_kind(n) = dice.uniq.select { dice.count(it) >= n }
  end
end
