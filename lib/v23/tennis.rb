module TennisKata

  SCORE_NAMES = ["Love", "Fifteen", "Thirty", "Forty"].freeze

  class TennisGame1

    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @p1points = 0
      @p2points = 0
    end
        
    def won_point(player_name)
      if player_name == @player1_name
        @p1points += 1
      else
        @p2points += 1
      end
    end
  
    def score
      return tied_score if @p1points == @p2points
      return late_game_score if @p1points >= 4 || @p2points >= 4

      regular_score(@p1points, @p2points)
    end

    private

    def tied_score
      return "Deuce" if @p1points >= 3

      "#{SCORE_NAMES[@p1points]}-All"
    end

    def late_game_score
      difference = @p1points - @p2points
      return "Advantage #{leading_player}" if difference.abs == 1

      "Win for #{leading_player}"
    end

    def leading_player
      @p1points > @p2points ? @player1_name : @player2_name
    end

    def regular_score(p1, p2)
      "#{SCORE_NAMES[p1]}-#{SCORE_NAMES[p2]}"
    end
  end

  class TennisGame2
    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @p1points = 0
      @p2points = 0
    end
      
    def won_point(player_name)
      if player_name == @player1_name
        p1_score
      else
        p2_score
      end
    end

    def score
      return tied_score if @p1points == @p2points
      return advantage_or_win if @p1points >= 4 || @p2points >= 4

      "#{SCORE_NAMES[@p1points]}-#{SCORE_NAMES[@p2points]}"
    end

    def setp1Score(number)
      (0..number).each { p1_score }
    end

    def setp2Score(number)
      (0..number).each { p2_score }
    end

    def p1_score
      @p1points += 1
    end

    def p2_score
      @p2points += 1
    end

    private

    def tied_score
      return "Deuce" if @p1points >= 3

      "#{SCORE_NAMES[@p1points]}-All"
    end

    def advantage_or_win
      difference = @p1points - @p2points
      if difference.abs == 1
        "Advantage #{difference.positive? ? @player1_name : @player2_name}"
      else
        "Win for #{difference.positive? ? @player1_name : @player2_name}"
      end
    end
  end

  class TennisGame3
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
      if regular_game?
        tied_regular? ? "#{SCORE_NAMES[@player1_points]}-All" : regular_score
      elsif @player1_points == @player2_points
        "Deuce"
      else
        result = advantage? ? "Advantage" : "Win for"
        "#{result} #{leading_player}"
      end
    end

    private

    def regular_game?
      @player1_points < 4 && @player2_points < 4 && (@player1_points + @player2_points < 6)
    end

    def tied_regular?
      @player1_points == @player2_points
    end

    def regular_score
      "#{SCORE_NAMES[@player1_points]}-#{SCORE_NAMES[@player2_points]}"
    end

    def leading_player
      @player1_points > @player2_points ? @player1_name : @player2_name
    end

    def advantage?
      (@player1_points - @player2_points).abs == 1
    end
  end
end
