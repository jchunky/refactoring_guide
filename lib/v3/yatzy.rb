module YatzyKata
  class Yatzy
    def initialize(*dice)
      @dice = dice.flatten
    end

    # Class methods for backward compatibility with original API
    def self.chance(*dice) = dice.sum
    def self.yatzy(dice) = dice.uniq.size == 1 ? 50 : 0
    def self.ones(*dice) = count_value(dice, 1)
    def self.twos(*dice) = count_value(dice, 2)
    def self.threes(*dice) = count_value(dice, 3)

    def self.score_pair(*dice) = highest_of_a_kind(dice, 2)
    def self.three_of_a_kind(*dice) = highest_of_a_kind(dice, 3)
    def self.four_of_a_kind(*dice) = highest_of_a_kind(dice, 4)

    def self.two_pair(*dice)
      pairs = tally(dice).select { |_, count| count >= 2 }.keys
      pairs.size == 2 ? pairs.sum * 2 : 0
    end

    def self.small_straight(*dice) = dice.sort == [1, 2, 3, 4, 5] ? 15 : 0
    def self.large_straight(*dice) = dice.sort == [2, 3, 4, 5, 6] ? 20 : 0

    def self.full_house(*dice)
      counts = tally(dice)
      has_pair = counts.value?(2)
      has_triple = counts.value?(3)
      has_pair && has_triple ? dice.sum : 0
    end

    # Instance methods
    def fours = count_value(@dice, 4)
    def fives = count_value(@dice, 5)
    def sixes = count_value(@dice, 6)

    private

    def count_value(dice, value) = dice.count(value) * value

    class << self
      private

      def count_value(dice, value) = dice.count(value) * value

      def tally(dice) = dice.tally

      def highest_of_a_kind(dice, count)
        match = tally(dice)
          .select { |_, cnt| cnt >= count }
          .keys
          .max
        match ? match * count : 0
      end
    end
  end
end
