module YatzyKata
  class Yatzy
    def self.method_missing(method, *args) = new(*args).receive(method)
    def self.respond_to_missing?(...) = true

    def initialize(*dice)
      @dice = dice.flatten
    end

    def receive(message)
      case message
      in :chance then @dice.sum
      in :ones then count_value(1)
      in :twos then count_value(2)
      in :threes then count_value(3)
      in :fours then count_value(4)
      in :fives then count_value(5)
      in :sixes then count_value(6)
      in :yatzy then @dice.uniq.one? ? 50 : 0
      in :score_pair then score_n_of_a_kind(2)
      in :three_of_a_kind then score_n_of_a_kind(3)
      in :four_of_a_kind then score_n_of_a_kind(4)
      in :small_straight then score_straight(1..5)
      in :large_straight then score_straight(2..6)
      in :two_pair then pairs.count == 2 ? pairs.sum * 2 : 0
      in :full_house then @dice.tally.values.sort == [2, 3] ? @dice.sum : 0
      end
    end

    # Forward instance methods to receive
    def chance = receive(:chance)
    def ones = receive(:ones)
    def twos = receive(:twos)
    def threes = receive(:threes)
    def fours = receive(:fours)
    def fives = receive(:fives)
    def sixes = receive(:sixes)
    def yatzy = receive(:yatzy)
    def score_pair = receive(:score_pair)
    def three_of_a_kind = receive(:three_of_a_kind)
    def four_of_a_kind = receive(:four_of_a_kind)
    def small_straight = receive(:small_straight)
    def large_straight = receive(:large_straight)
    def two_pair = receive(:two_pair)
    def full_house = receive(:full_house)

    private

    def count_value(v) = @dice.count(v) * v
    def pairs = find_n_of_a_kind(2)
    def score_n_of_a_kind(n) = find_n_of_a_kind(n).max.to_i * n
    def score_straight(range) = @dice.sort == range.to_a ? @dice.sum : 0
    def find_n_of_a_kind(n) = @dice.uniq.select { @dice.count(it) >= n }
  end
end
