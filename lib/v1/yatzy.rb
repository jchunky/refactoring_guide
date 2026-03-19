module YatzyKata
  class Yatzy
    def initialize(*dice)
      @dice = dice
    end

    def self.chance(*dice)
      dice.sum
    end

    def self.yatzy(dice)
      dice.uniq.size == 1 ? 50 : 0
    end

    def self.ones(*dice) = new(*dice).count_die(1)
    def self.twos(*dice) = new(*dice).count_die(2)
    def self.threes(*dice) = new(*dice).count_die(3)

    def self.score_pair(*dice)
      new(*dice).highest_n_of_a_kind(2)
    end

    def self.two_pair(*dice)
      new(*dice).two_pair
    end

    def self.three_of_a_kind(*dice)
      new(*dice).n_of_a_kind(3)
    end

    def self.four_of_a_kind(*dice)
      new(*dice).n_of_a_kind(4)
    end

    def self.small_straight(*dice)
      dice.sort == [1, 2, 3, 4, 5] ? 15 : 0
    end

    def self.large_straight(*dice)
      dice.sort == [2, 3, 4, 5, 6] ? 20 : 0
    end

    def self.full_house(*dice)
      new(*dice).full_house
    end

    def fours = count_die(4)
    def fives = count_die(5)
    def sixes = count_die(6)

    def count_die(value)
      @dice.count(value) * value
    end

    def two_pair
      pairs = tallies.each_with_index
                      .select { |count, _| count >= 2 }
                      .map { |_, index| index + 1 }
      pairs.size == 2 ? pairs.sum * 2 : 0
    end

    def full_house
      counts = tallies
      has_two = counts.index(2)
      has_three = counts.index(3)
      return 0 unless has_two && has_three

      (has_two + 1) * 2 + (has_three + 1) * 3
    end

    def n_of_a_kind(n)
      tallies.each_with_index do |count, index|
        return (index + 1) * n if count >= n
      end
      0
    end

    def highest_n_of_a_kind(n)
      tallies.each_with_index.reverse_each do |count, index|
        return (index + 1) * n if count >= n
      end
      0
    end

    private

    def tallies
      result = [0] * 6
      @dice.each { |die| result[die - 1] += 1 }
      result
    end
  end
end
