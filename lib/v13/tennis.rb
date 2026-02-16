module TennisKata
  SCORE_NAMES = { 0 => "Love", 1 => "Fifteen", 2 => "Thirty", 3 => "Forty" }.freeze

  module TennisScoring
    private

    def compute_score(p1, p2, player1, player2)
      case [p1, p2]
      in [s, ^s] if s >= 3                     then "Deuce"
      in [s, ^s]                                then "#{SCORE_NAMES[s]}-All"
      in [a, b] if a >= 3 && b >= 3            then advantage_or_win(a, b, player1, player2)
      in [a, b] if a < 4 && b < 4              then "#{SCORE_NAMES[a]}-#{SCORE_NAMES[b]}"
      in [4.., _]                               then "Win for #{player1}"
      in [_, 4..]                               then "Win for #{player2}"
      end
    end

    def advantage_or_win(p1, p2, player1, player2)
      case p1 - p2
      in 1    then "Advantage #{player1}"
      in -1   then "Advantage #{player2}"
      in 2..  then "Win for #{player1}"
      in ..-2 then "Win for #{player2}"
      end
    end
  end

  class TennisGame1
    include TennisScoring

    def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
      @p1points = 0
      @p2points = 0
    end

    def won_point(name)
      name == @player1 ? @p1points += 1 : @p2points += 1
    end

    def score = compute_score(@p1points, @p2points, @player1, @player2)
  end

  class TennisGame2
    include TennisScoring

    def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
      @p1points = 0
      @p2points = 0
    end

    def won_point(name)
      name == @player1 ? @p1points += 1 : @p2points += 1
    end

    def score = compute_score(@p1points, @p2points, @player1, @player2)

    def setp1Score(number) = (0..number).each { p1Score }
    def setp2Score(number) = (0..number).each { p2Score }
    def p1Score = @p1points += 1
    def p2Score = @p2points += 1
  end

  class TennisGame3
    include TennisScoring

    def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
      @p1 = 0
      @p2 = 0
    end

    def won_point(name)
      name == @player1 ? @p1 += 1 : @p2 += 1
    end

    def score = compute_score(@p1, @p2, @player1, @player2)
  end
end
