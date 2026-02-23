# frozen_string_literal: true

module TennisKata
  SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

  module TennisScoring
    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @p1_points = 0
      @p2_points = 0
    end

    def won_point(player_name)
      if player_name == @player1_name
        @p1_points += 1
      else
        @p2_points += 1
      end
    end

    private

    def tied_score
      @p1_points >= 3 ? "Deuce" : "#{SCORE_NAMES[@p1_points]}-All"
    end

    def advantage_or_win_score
      diff = @p1_points - @p2_points
      leader = diff > 0 ? @player1_name : @player2_name
      diff.abs == 1 ? "Advantage #{leader}" : "Win for #{leader}"
    end

    def running_score
      "#{SCORE_NAMES[@p1_points]}-#{SCORE_NAMES[@p2_points]}"
    end
  end

  class TennisGame1
    include TennisScoring

    def score
      return tied_score if @p1_points == @p2_points
      return advantage_or_win_score if @p1_points >= 4 || @p2_points >= 4

      running_score
    end
  end

  class TennisGame2
    include TennisScoring

    def score
      return tied_score if @p1_points == @p2_points
      return advantage_or_win_score if @p1_points >= 4 || @p2_points >= 4

      running_score
    end
  end

  class TennisGame3
    include TennisScoring

    def score
      return tied_score if @p1_points == @p2_points
      return advantage_or_win_score if @p1_points >= 4 || @p2_points >= 4

      running_score
    end
  end
end
