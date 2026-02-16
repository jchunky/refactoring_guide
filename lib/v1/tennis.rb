module TennisKata
  class TennisGame1
    SCORE_NAMES = {
      0 => "Love",
      1 => "Fifteen",
      2 => "Thirty",
      3 => "Forty"
    }.freeze

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
      if tied?
        tied_score
      elsif in_endgame?
        endgame_score
      else
        regular_score
      end
    end

    private

    def tied?
      @player1_points == @player2_points
    end

    def in_endgame?
      @player1_points >= 4 || @player2_points >= 4
    end

    def tied_score
      return "Deuce" if @player1_points >= 3
      "#{SCORE_NAMES[@player1_points]}-All"
    end

    def endgame_score
      point_difference = @player1_points - @player2_points

      case point_difference
      when 1 then "Advantage #{@player1_name}"
      when -1 then "Advantage #{@player2_name}"
      when 2.. then "Win for #{@player1_name}"
      else "Win for #{@player2_name}"
      end
    end

    def regular_score
      "#{SCORE_NAMES[@player1_points]}-#{SCORE_NAMES[@player2_points]}"
    end
  end

  class TennisGame2
    SCORE_NAMES = {
      0 => "Love",
      1 => "Fifteen",
      2 => "Thirty",
      3 => "Forty"
    }.freeze

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
      if tied?
        tied_score
      elsif advantage?
        advantage_score
      elsif won?
        win_score
      else
        regular_score
      end
    end

    private

    def tied?
      @player1_points == @player2_points
    end

    def advantage?
      both_at_deuce? && point_difference.abs == 1
    end

    def won?
      (@player1_points >= 4 || @player2_points >= 4) && point_difference.abs >= 2
    end

    def both_at_deuce?
      @player1_points >= 3 && @player2_points >= 3
    end

    def point_difference
      @player1_points - @player2_points
    end

    def tied_score
      return "Deuce" if @player1_points >= 3
      "#{SCORE_NAMES[@player1_points]}-All"
    end

    def advantage_score
      leader = point_difference > 0 ? @player1_name : @player2_name
      "Advantage #{leader}"
    end

    def win_score
      winner = point_difference > 0 ? @player1_name : @player2_name
      "Win for #{winner}"
    end

    def regular_score
      "#{SCORE_NAMES[@player1_points]}-#{SCORE_NAMES[@player2_points]}"
    end
  end

  class TennisGame3
    SCORE_NAMES = ["Love", "Fifteen", "Thirty", "Forty"].freeze

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
      if in_regular_game?
        regular_score
      elsif tied?
        "Deuce"
      elsif advantage?
        "Advantage #{leader_name}"
      else
        "Win for #{leader_name}"
      end
    end

    private

    def in_regular_game?
      @player1_points < 4 && @player2_points < 4 && total_points < 6
    end

    def tied?
      @player1_points == @player2_points
    end

    def advantage?
      point_difference_squared == 1
    end

    def total_points
      @player1_points + @player2_points
    end

    def point_difference_squared
      (@player1_points - @player2_points) ** 2
    end

    def leader_name
      @player1_points > @player2_points ? @player1_name : @player2_name
    end

    def regular_score
      score_string = SCORE_NAMES[@player1_points]
      tied? ? "#{score_string}-All" : "#{score_string}-#{SCORE_NAMES[@player2_points]}"
    end
  end
end
