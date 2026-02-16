# Yatzy Scoring Kata
#
# Yatzy is a dice game where players roll 5 dice and score based on combinations.
# Each scoring category has specific rules for calculating points.
#
# Dice values range from 1 to 6.
# The game involves choosing which category to score each roll in.

module YatzyKata
  class Yatzy
    # Number of dice in a standard Yatzy game
    NUMBER_OF_DICE = 5

    # Possible die face values
    DIE_FACE_VALUES = (1..6).freeze

    # Points awarded for a Yatzy (all five dice showing the same value)
    YATZY_SCORE = 50

    # Initialize with 5 dice values
    def initialize(die1, die2, die3, die4, die5)
      @dice = [die1, die2, die3, die4, die5]
    end

    # ============================================
    # CHANCE: Sum of all dice, regardless of values
    # ============================================
    def self.chance(die1, die2, die3, die4, die5)
      die1 + die2 + die3 + die4 + die5
    end

    # ============================================
    # YATZY: All five dice show the same value = 50 points
    # ============================================
    def self.yatzy(dice)
      all_dice_same_value?(dice) ? YATZY_SCORE : 0
    end

    def self.all_dice_same_value?(dice)
      dice.uniq.length == 1
    end

    # ============================================
    # UPPER SECTION: Score sum of dice showing specific value
    # ============================================

    # Ones: Sum of all dice showing 1
    def self.ones(die1, die2, die3, die4, die5)
      sum_of_dice_matching_value([die1, die2, die3, die4, die5], target_value: 1)
    end

    # Twos: Sum of all dice showing 2
    def self.twos(die1, die2, die3, die4, die5)
      sum_of_dice_matching_value([die1, die2, die3, die4, die5], target_value: 2)
    end

    # Threes: Sum of all dice showing 3
    def self.threes(die1, die2, die3, die4, die5)
      sum_of_dice_matching_value([die1, die2, die3, die4, die5], target_value: 3)
    end

    # Instance methods for remaining upper section scores
    def fours
      sum_of_dice_matching_value(@dice, target_value: 4)
    end

    def fives
      sum_of_dice_matching_value(@dice, target_value: 5)
    end

    def sixes
      sum_of_dice_matching_value(@dice, target_value: 6)
    end

    # ============================================
    # PAIRS AND MULTIPLES
    # ============================================

    # Score Pair: Two dice showing the same value
    # Returns double the highest matching pair value
    def self.score_pair(die1, die2, die3, die4, die5)
      dice = [die1, die2, die3, die4, die5]
      value_counts = count_dice_by_value(dice)

      # Find highest value that appears at least twice
      highest_pair_value = DIE_FACE_VALUES.to_a.reverse.find { |value| value_counts[value] >= 2 }

      highest_pair_value ? highest_pair_value * 2 : 0
    end

    # Two Pair: Two different pairs
    # Returns sum of both pairs (each pair value * 2)
    def self.two_pair(die1, die2, die3, die4, die5)
      dice = [die1, die2, die3, die4, die5]
      value_counts = count_dice_by_value(dice)

      # Find all values that appear at least twice
      pair_values = DIE_FACE_VALUES.select { |value| value_counts[value] >= 2 }

      if pair_values.length >= 2
        pair_values.sum * 2
      else
        0
      end
    end

    # Three of a Kind: Three dice showing the same value
    def self.three_of_a_kind(die1, die2, die3, die4, die5)
      dice = [die1, die2, die3, die4, die5]
      score_n_of_a_kind(dice, required_count: 3)
    end

    # Four of a Kind: Four dice showing the same value
    def self.four_of_a_kind(die1, die2, die3, die4, die5)
      dice = [die1, die2, die3, die4, die5]
      score_n_of_a_kind(dice, required_count: 4)
    end

    # ============================================
    # STRAIGHTS
    # ============================================

    # Small Straight: Dice showing 1, 2, 3, 4, 5 = 15 points
    def self.small_straight(die1, die2, die3, die4, die5)
      dice = [die1, die2, die3, die4, die5]
      small_straight_values = [1, 2, 3, 4, 5]

      dice.sort == small_straight_values ? 15 : 0
    end

    # Large Straight: Dice showing 2, 3, 4, 5, 6 = 20 points
    def self.large_straight(die1, die2, die3, die4, die5)
      dice = [die1, die2, die3, die4, die5]
      large_straight_values = [2, 3, 4, 5, 6]

      dice.sort == large_straight_values ? 20 : 0
    end

    # ============================================
    # FULL HOUSE: Three of one value + Two of another
    # ============================================
    def self.full_house(die1, die2, die3, die4, die5)
      dice = [die1, die2, die3, die4, die5]
      value_counts = count_dice_by_value(dice)

      # Find values that form pairs and three-of-a-kind
      pair_value = DIE_FACE_VALUES.find { |value| value_counts[value] == 2 }
      three_of_a_kind_value = DIE_FACE_VALUES.find { |value| value_counts[value] == 3 }

      if pair_value && three_of_a_kind_value
        (pair_value * 2) + (three_of_a_kind_value * 3)
      else
        0
      end
    end

    # ============================================
    # HELPER METHODS
    # ============================================

    private

    # Sum all dice that match the target value
    def sum_of_dice_matching_value(dice, target_value:)
      dice.count(target_value) * target_value
    end

    # Class-level helper: Sum all dice that match the target value
    def self.sum_of_dice_matching_value(dice, target_value:)
      dice.count(target_value) * target_value
    end

    # Count how many times each die value appears
    # Returns a hash: { 1 => count, 2 => count, ... 6 => count }
    def self.count_dice_by_value(dice)
      counts = Hash.new(0)
      dice.each { |die| counts[die] += 1 }
      counts
    end

    # Score for N-of-a-kind combinations
    # Returns (die_value * required_count) if found, 0 otherwise
    def self.score_n_of_a_kind(dice, required_count:)
      value_counts = count_dice_by_value(dice)

      matching_value = DIE_FACE_VALUES.find { |value| value_counts[value] >= required_count }

      matching_value ? matching_value * required_count : 0
    end
  end
end
