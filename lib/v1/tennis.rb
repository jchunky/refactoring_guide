module TennisKata
  SCORE_NAMES = ["Love", "Fifteen", "Thirty", "Forty"].freeze

  class TennisGame1
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

    def score
      if @p1_points == @p2_points
        return deuce_or_all
      end

      if @p1_points >= 4 || @p2_points >= 4
        return endgame_score
      end

      "#{SCORE_NAMES[@p1_points]}-#{SCORE_NAMES[@p2_points]}"
    end

    private

    def deuce_or_all
      return "Deuce" if @p1_points >= 3

      "#{SCORE_NAMES[@p1_points]}-All"
    end

    def endgame_score
      difference = @p1_points - @p2_points
      leader = difference > 0 ? @player1_name : @player2_name

      difference.abs == 1 ? "Advantage #{leader}" : "Win for #{leader}"
    end
  end

  class TennisGame2
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

    def score
      if @p1_points == @p2_points
        return @p1_points >= 3 ? "Deuce" : "#{SCORE_NAMES[@p1_points]}-All"
      end

      if @p1_points >= 4 || @p2_points >= 4
        leader = @p1_points > @p2_points ? @player1_name : @player2_name
        difference = (@p1_points - @p2_points).abs
        return difference == 1 ? "Advantage #{leader}" : "Win for #{leader}"
      end

      "#{SCORE_NAMES[@p1_points]}-#{SCORE_NAMES[@p2_points]}"
    end
  end

  class TennisGame3
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

    def score
      if @p1_points < 4 && @p2_points < 4 && @p1_points + @p2_points < 6
        score_name = SCORE_NAMES[@p1_points]
        return @p1_points == @p2_points ? "#{score_name}-All" : "#{score_name}-#{SCORE_NAMES[@p2_points]}"
      end

      return "Deuce" if @p1_points == @p2_points

      leader = @p1_points > @p2_points ? @player1_name : @player2_name
      (@p1_points - @p2_points).abs == 1 ? "Advantage #{leader}" : "Win for #{leader}"
    end
  end
end
