module YatzyKata
  class Yatzy
    def initialize(*dice)
      @dice = dice
    end

    # --- Chance & Yatzy ---

    def self.chance(*dice)
      new(*dice).chance
    end

    def chance
      @dice.sum
    end

    def self.yatzy(dice)
      new(*dice).yatzy
    end

    def yatzy
      @dice.uniq.length == 1 ? 50 : 0
    end

    # --- Count specific face values ---

    def self.ones(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).ones
    end

    def self.twos(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).twos
    end

    def self.threes(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).threes
    end

    def ones
      count_face(1)
    end

    def twos
      count_face(2)
    end

    def threes
      count_face(3)
    end

    def fours
      count_face(4)
    end

    def fives
      count_face(5)
    end

    def sixes
      count_face(6)
    end

    # --- Pairs and N-of-a-kind ---

    def self.score_pair(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).score_pair
    end

    def self.two_pair(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).two_pair
    end

    def self.three_of_a_kind(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).three_of_a_kind
    end

    def self.four_of_a_kind(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).four_of_a_kind
    end

    def score_pair
      6.downto(1) do |i|
        return i * 2 if tally[i - 1] >= 2
      end
      0
    end

    def two_pair
      pairs = (1..6).select { |i| tally[i - 1] >= 2 }
      pairs.length == 2 ? pairs.sum * 2 : 0
    end

    def three_of_a_kind
      n_of_a_kind(3)
    end

    def four_of_a_kind
      n_of_a_kind(4)
    end

    # --- Straights ---

    def self.small_straight(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).small_straight
    end

    def self.large_straight(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).large_straight
    end

    def small_straight
      @dice.sort == [1, 2, 3, 4, 5] ? 15 : 0
    end

    def large_straight
      @dice.sort == [2, 3, 4, 5, 6] ? 20 : 0
    end

    # --- Full House ---

    def self.full_house(d1, d2, d3, d4, d5)
      new(d1, d2, d3, d4, d5).full_house
    end

    def full_house
      has_two = (1..6).find { |i| tally[i - 1] == 2 }
      has_three = (1..6).find { |i| tally[i - 1] == 3 }
      has_two && has_three ? has_two * 2 + has_three * 3 : 0
    end

    private

    def count_face(face)
      @dice.count(face) * face
    end

    def tally
      @tally ||= begin
        tallies = [0] * 6
        @dice.each { |d| tallies[d - 1] += 1 }
        tallies
      end
    end

    def n_of_a_kind(n)
      (1..6).each do |i|
        return i * n if tally[i - 1] >= n
      end
      0
    end
  end
end
