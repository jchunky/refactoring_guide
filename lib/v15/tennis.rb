module TennisKata
  PlayerState = Data.define(:name, :points)

  SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

  module ScoreFn
    def self.score_name(points) = SCORE_NAMES[points]

    def self.score(p1, p2)
      diff = (p1.points - p2.points).abs
      max = [p1.points, p2.points].max
      leader = p1.points >= p2.points ? p1 : p2

      case [diff, max]
      in [0, ..2] then "#{score_name(leader.points)}-All"
      in [0, 3..] then "Deuce"
      in [1.., ..3] then "#{score_name(p1.points)}-#{score_name(p2.points)}"
      in [1, 4..] then "Advantage #{leader.name}"
      in [2.., 4..] then "Win for #{leader.name}"
      end
    end
  end

  class TennisGame
    def initialize(name1, name2)
      @player1 = PlayerState.new(name: name1, points: 0)
      @player2 = PlayerState.new(name: name2, points: 0)
    end

    def won_point(player_name)
      if @player1.name == player_name
        @player1 = PlayerState.new(name: @player1.name, points: @player1.points + 1)
      else
        @player2 = PlayerState.new(name: @player2.name, points: @player2.points + 1)
      end
    end

    def score = ScoreFn.score(@player1, @player2)
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
