# Tennis Scoring Kata
#
# Tennis scoring rules:
# - Points progress: 0 (Love) → 15 → 30 → 40
# - When tied at 40-40, it's called "Deuce"
# - After Deuce, the player who scores has "Advantage"
# - If the player with Advantage scores again, they win
# - If the other player scores, it returns to Deuce
# - A player must win by 2 points after reaching 40

module TennisKata
  # Score names for displaying tennis points
  SCORE_NAMES = {
    0 => "Love",
    1 => "Fifteen",
    2 => "Thirty",
    3 => "Forty"
  }.freeze

  # Implementation 1: Hash-based approach with clear conditionals
  class TennisGame1
    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @player1_points = 0
      @player2_points = 0
    end

    def won_point(player_name)
      if player_name == @player1_name
        @player1_points += 1
      else
        @player2_points += 1
      end
    end

    def score
      if scores_are_tied?
        tied_score_description
      elsif game_is_in_endgame?
        endgame_score_description
      else
        regular_score_description
      end
    end

    private

    def scores_are_tied?
      @player1_points == @player2_points
    end

    def game_is_in_endgame?
      # Endgame begins when either player has 4+ points (possible advantage or win)
      @player1_points >= 4 || @player2_points >= 4
    end

    def tied_score_description
      if @player1_points >= 3
        "Deuce"
      else
        "#{SCORE_NAMES[@player1_points]}-All"
      end
    end

    def endgame_score_description
      point_difference = @player1_points - @player2_points
      leading_player = point_difference > 0 ? @player1_name : @player2_name

      if point_difference.abs == 1
        "Advantage #{leading_player}"
      else
        "Win for #{leading_player}"
      end
    end

    def regular_score_description
      "#{SCORE_NAMES[@player1_points]}-#{SCORE_NAMES[@player2_points]}"
    end
  end

  # Implementation 2: Explicit conditionals (refactored for clarity)
  class TennisGame2
    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @player1_points = 0
      @player2_points = 0
    end

    def won_point(player_name)
      if player_name == @player1_name
        increment_player1_score
      else
        increment_player2_score
      end
    end

    def score
      return tied_score if scores_are_tied?
      return advantage_or_win_score if in_advantage_or_win_situation?
      regular_score
    end

    # Test helper methods for setting scores
    def set_player1_score(number)
      (0..number).each { increment_player1_score }
    end

    def set_player2_score(number)
      (0..number).each { increment_player2_score }
    end

    def increment_player1_score
      @player1_points += 1
    end

    def increment_player2_score
      @player2_points += 1
    end

    private

    def scores_are_tied?
      @player1_points == @player2_points
    end

    def in_advantage_or_win_situation?
      @player1_points >= 4 || @player2_points >= 4
    end

    def tied_score
      if @player1_points >= 3
        "Deuce"
      else
        "#{SCORE_NAMES[@player1_points]}-All"
      end
    end

    def advantage_or_win_score
      point_difference = @player1_points - @player2_points
      leading_player = point_difference > 0 ? @player1_name : @player2_name

      if both_players_at_deuce_or_beyond? && point_difference.abs == 1
        "Advantage #{leading_player}"
      elsif point_difference.abs >= 2
        "Win for #{leading_player}"
      else
        "Advantage #{leading_player}"
      end
    end

    def both_players_at_deuce_or_beyond?
      @player1_points >= 3 && @player2_points >= 3
    end

    def regular_score
      "#{SCORE_NAMES[@player1_points]}-#{SCORE_NAMES[@player2_points]}"
    end
  end

  # Implementation 3: Compact version (refactored for readability)
  class TennisGame3
    MINIMUM_POINTS_FOR_DEUCE = 3
    MINIMUM_TOTAL_POINTS_FOR_ENDGAME = 6
    POINTS_REQUIRED_TO_WIN = 4

    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @player1_points = 0
      @player2_points = 0
    end

    def won_point(player_name)
      if player_name == @player1_name
        @player1_points += 1
      else
        @player2_points += 1
      end
    end

    def score
      if in_regular_play?
        regular_score
      else
        endgame_score
      end
    end

    private

    def in_regular_play?
      both_players_below_win_threshold? && total_points_below_endgame_threshold?
    end

    def both_players_below_win_threshold?
      @player1_points < POINTS_REQUIRED_TO_WIN && @player2_points < POINTS_REQUIRED_TO_WIN
    end

    def total_points_below_endgame_threshold?
      @player1_points + @player2_points < MINIMUM_TOTAL_POINTS_FOR_ENDGAME
    end

    def regular_score
      player1_score_name = SCORE_NAMES[@player1_points]
      player2_score_name = SCORE_NAMES[@player2_points]

      if scores_are_tied?
        "#{player1_score_name}-All"
      else
        "#{player1_score_name}-#{player2_score_name}"
      end
    end

    def endgame_score
      return "Deuce" if scores_are_tied?

      leading_player = @player1_points > @player2_points ? @player1_name : @player2_name
      point_difference_squared = (@player1_points - @player2_points) ** 2

      if point_difference_squared == 1
        "Advantage #{leading_player}"
      else
        "Win for #{leading_player}"
      end
    end

    def scores_are_tied?
      @player1_points == @player2_points
    end
  end
end
