module TennisKata
  SCORE_NAMES = {
    0 => "Love",
    1 => "Fifteen",
    2 => "Thirty",
    3 => "Forty"
  }.freeze

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
      if @p1points == @p2points
        return @p1points >= 3 ? "Deuce" : "#{SCORE_NAMES[@p1points]}-All"
      end

      if @p1points >= 4 || @p2points >= 4
        diff = @p1points - @p2points
        leader = diff > 0 ? @player1_name : @player2_name
        return diff.abs == 1 ? "Advantage #{leader}" : "Win for #{leader}"
      end

      "#{SCORE_NAMES[@p1points]}-#{SCORE_NAMES[@p2points]}"
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
        @p1points += 1
      else
        @p2points += 1
      end
    end

    def score
      if @p1points == @p2points
        return @p1points >= 3 ? "Deuce" : "#{SCORE_NAMES[@p1points]}-All"
      end

      if @p1points >= 4 || @p2points >= 4
        diff = @p1points - @p2points
        leader = diff > 0 ? @player1_name : @player2_name
        if diff.abs == 1
          return "Advantage #{leader}"
        else
          return "Win for #{leader}"
        end
      end

      "#{SCORE_NAMES[@p1points]}-#{SCORE_NAMES[@p2points]}"
    end

    def setp1Score(number)
      (0..number).each { p1Score }
    end

    def setp2Score(number)
      (0..number).each { p2Score }
    end

    def p1Score
      @p1points += 1
    end

    def p2Score
      @p2points += 1
    end
  end

  class TennisGame3
    def initialize(player1_name, player2_name)
      @p1_name = player1_name
      @p2_name = player2_name
      @p1 = 0
      @p2 = 0
    end

    def won_point(name)
      if name == @p1_name
        @p1 += 1
      else
        @p2 += 1
      end
    end

    def score
      if (@p1 < 4 && @p2 < 4) && (@p1 + @p2 < 6)
        s = SCORE_NAMES[@p1]
        @p1 == @p2 ? "#{s}-All" : "#{s}-#{SCORE_NAMES[@p2]}"
      elsif @p1 == @p2
        "Deuce"
      else
        leader = @p1 > @p2 ? @p1_name : @p2_name
        (@p1 - @p2).abs == 1 ? "Advantage #{leader}" : "Win for #{leader}"
      end
    end
  end
end
