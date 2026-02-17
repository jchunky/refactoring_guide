module YatzyKata
  class Yatzy < Data.define(:dice)
    def self.new(*dice) = super(dice: dice.flatten.freeze)
    def self.method_missing(method, *args) = new(*args).send(method)
    def self.respond_to_missing?(method, include_private = false) = instance_methods.include?(method) || super

    def chance = dice.sum

    def ones = count_value(1)
    def twos = count_value(2)
    def threes = count_value(3)
    def fours = count_value(4)
    def fives = count_value(5)
    def sixes = count_value(6)

    def yatzy
      case dice.uniq.size
      in 1 then 50
      else 0
      end
    end

    def score_pair = score_n_of_a_kind(2)
    def three_of_a_kind = score_n_of_a_kind(3)
    def four_of_a_kind = score_n_of_a_kind(4)

    def small_straight
      case dice.sort
      in [1, 2, 3, 4, 5] then 15
      else 0
      end
    end

    def large_straight
      case dice.sort
      in [2, 3, 4, 5, 6] then 20
      else 0
      end
    end

    def two_pair
      case pairs
      in [_, _] then pairs.sum * 2
      else 0
      end
    end

    def full_house
      case dice.tally.values.sort
      in [2, 3] then dice.sum
      else 0
      end
    end

    private

    def count_value(v) = dice.count(v) * v
    def pairs = find_n_of_a_kind(2)
    def score_n_of_a_kind(n) = find_n_of_a_kind(n).max.to_i * n
    def find_n_of_a_kind(n) = dice.uniq.select { dice.count(it) >= n }
  end
end
