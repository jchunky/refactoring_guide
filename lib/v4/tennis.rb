module TennisKata
  class TennisGame1
    SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @p1points = 0
      @p2points = 0
    end

    def won_point(player_name)
      player_name == @player1_name ? @p1points += 1 : @p2points += 1
    end

    def score
      return tied_score if tied?
      return endgame_score if endgame?
      "#{SCORE_NAMES[@p1points]}-#{SCORE_NAMES[@p2points]}"
    end

    private

    def tied?
      @p1points == @p2points
    end

    def endgame?
      @p1points >= 4 || @p2points >= 4
    end

    def tied_score
      @p1points >= 3 ? "Deuce" : "#{SCORE_NAMES[@p1points]}-All"
    end

    def endgame_score
      diff = @p1points - @p2points
      leader = diff > 0 ? @player1_name : @player2_name
      diff.abs == 1 ? "Advantage #{leader}" : "Win for #{leader}"
    end
  end

  class TennisGame2
    SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

    def initialize(player1_name, player2_name)
      @player1_name = player1_name
      @player2_name = player2_name
      @p1points = 0
      @p2points = 0
    end

    def won_point(player_name)
      player_name == @player1_name ? p1Score : p2Score
    end

    def score
      return tied_score if tied?
      return endgame_score if endgame?
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

    private

    def tied?
      @p1points == @p2points
    end

    def endgame?
      @p1points >= 4 || @p2points >= 4
    end

    def tied_score
      @p1points >= 3 ? "Deuce" : "#{SCORE_NAMES[@p1points]}-All"
    end

    def endgame_score
      diff = @p1points - @p2points
      leader = diff > 0 ? @player1_name : @player2_name
      diff.abs >= 2 ? "Win for #{leader}" : "Advantage #{leader}"
    end
  end

  class TennisGame3
    SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

    def initialize(player1_name, player2_name)
      @p1N = player1_name
      @p2N = player2_name
      @p1 = 0
      @p2 = 0
    end

    def won_point(name)
      name == @p1N ? @p1 += 1 : @p2 += 1
    end

    def score
      return "Deuce" if @p1 == @p2 && @p1 >= 3
      return "#{SCORE_NAMES[@p1]}-All" if @p1 == @p2
      return "#{SCORE_NAMES[@p1]}-#{SCORE_NAMES[@p2]}" if @p1 < 4 && @p2 < 4

      leader = @p1 > @p2 ? @p1N : @p2N
      (@p1 - @p2).abs == 1 ? "Advantage #{leader}" : "Win for #{leader}"
    end
  end
end
