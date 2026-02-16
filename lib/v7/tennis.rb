module TennisKata
  class TennisGame1
    SCORE_NAMES = { 0 => "Love", 1 => "Fifteen", 2 => "Thirty", 3 => "Forty" }

    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @p1_points = 0
      @p2_points = 0
    end

    def won_point(player_name)
      player_name == @player1_name ? @p1_points += 1 : @p2_points += 1
    end

    def score
      return tied_score if @p1_points == @p2_points
      return endgame_score if @p1_points >= 4 || @p2_points >= 4
      "#{SCORE_NAMES[@p1_points]}-#{SCORE_NAMES[@p2_points]}"
    end

    private

    def tied_score
      @p1_points >= 3 ? "Deuce" : "#{SCORE_NAMES[@p1_points]}-All"
    end

    def endgame_score
      diff = @p1_points - @p2_points
      leader = diff > 0 ? @player1_name : @player2_name
      diff.abs >= 2 ? "Win for #{leader}" : "Advantage #{leader}"
    end
  end

  class TennisGame2
    SCORE_NAMES = { 0 => "Love", 1 => "Fifteen", 2 => "Thirty", 3 => "Forty" }

    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @p1_points = 0
      @p2_points = 0
    end

    def won_point(player_name)
      player_name == @player1_name ? @p1_points += 1 : @p2_points += 1
    end

    def score
      return tied_score if @p1_points == @p2_points
      return endgame_score if @p1_points >= 4 || @p2_points >= 4
      "#{SCORE_NAMES[@p1_points]}-#{SCORE_NAMES[@p2_points]}"
    end

    def setp1Score(number)
      (0..number).each { p1Score }
    end

    def setp2Score(number)
      (0..number).each { p2Score }
    end

    def p1Score
      @p1_points += 1
    end

    def p2Score
      @p2_points += 1
    end

    private

    def tied_score
      @p1_points >= 3 ? "Deuce" : "#{SCORE_NAMES[@p1_points]}-All"
    end

    def endgame_score
      diff = @p1_points - @p2_points
      leader = diff > 0 ? @player1_name : @player2_name
      diff.abs >= 2 ? "Win for #{leader}" : "Advantage #{leader}"
    end
  end

  class TennisGame3
    SCORE_NAMES = ["Love", "Fifteen", "Thirty", "Forty"]

    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @p1 = 0
      @p2 = 0
    end

    def won_point(name)
      name == @player1_name ? @p1 += 1 : @p2 += 1
    end

    def score
      return deuce_or_endgame if @p1 >= 3 && @p2 >= 3
      return regular_score if @p1 < 4 && @p2 < 4
      endgame_score
    end

    private

    def regular_score
      @p1 == @p2 ? "#{SCORE_NAMES[@p1]}-All" : "#{SCORE_NAMES[@p1]}-#{SCORE_NAMES[@p2]}"
    end

    def deuce_or_endgame
      return "Deuce" if @p1 == @p2
      endgame_score
    end

    def endgame_score
      diff = @p1 - @p2
      leader = diff > 0 ? @player1_name : @player2_name
      diff.abs == 1 ? "Advantage #{leader}" : "Win for #{leader}"
    end
  end
end
