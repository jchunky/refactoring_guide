module YatzyKata
  class Yatzy < Struct.new(:dice)
    def self.method_missing(method, *) = new(*).send(method)

    def initialize(*dice) = super(dice.flatten)

    def chance = dice.then(&:sum)
    def ones = dice.then { it.count(1) * 1 }
    def twos = dice.then { it.count(2) * 2 }
    def threes = dice.then { it.count(3) * 3 }
    def fours = dice.then { it.count(4) * 4 }
    def fives = dice.then { it.count(5) * 5 }
    def sixes = dice.then { it.count(6) * 6 }
    def yatzy = dice.then { it.uniq.one? ? 50 : 0 }

    def score_pair = dice.then { find_n_of_a_kind(it, 2) }.then { it.max.to_i * 2 }
    def three_of_a_kind = dice.then { find_n_of_a_kind(it, 3) }.then { it.max.to_i * 3 }
    def four_of_a_kind = dice.then { find_n_of_a_kind(it, 4) }.then { it.max.to_i * 4 }

    def small_straight = dice.sort == (1..5).to_a ? dice.sum : 0
    def large_straight = dice.sort == (2..6).to_a ? dice.sum : 0

    def two_pair
      dice.then { find_n_of_a_kind(it, 2) }
          .then { it.count == 2 ? it.sum * 2 : 0 }
    end

    def full_house
      dice.then { it.tally.values.sort }
          .then { it == [2, 3] ? dice.sum : 0 }
    end

    private

    def find_n_of_a_kind(d, n) = d.uniq.select { d.count(it) >= n }
  end
end
