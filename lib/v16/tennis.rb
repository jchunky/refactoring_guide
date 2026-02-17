module TennisKata
  PlayerData = Data.define(:name, :points)

  SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

  module ScoreFn
    def self.compute(p1, p2)
      diff = (p1.points - p2.points).abs
      max = [p1.points, p2.points].max
      leader = p1.points >= p2.points ? p1 : p2

      case [diff, max]
      in [0, 0] then "Love-All"
      in [0, 1] then "Fifteen-All"
      in [0, 2] then "Thirty-All"
      in [0, 3..] then "Deuce"
      in [1.., 0..3] then "#{SCORE_NAMES[p1.points]}-#{SCORE_NAMES[p2.points]}"
      in [1, 4..] then "Advantage #{leader.name}"
      in [2.., 4..] then "Win for #{leader.name}"
      end
    end
  end

  class TennisGame
    def initialize(name1, name2)
      @p1 = PlayerData.new(name: name1, points: 0)
      @p2 = PlayerData.new(name: name2, points: 0)
    end

    def won_point(player_name)
      case player_name
      in ^(-> n { n == @p1.name })
        @p1 = PlayerData.new(name: @p1.name, points: @p1.points + 1)
      else
        @p2 = PlayerData.new(name: @p2.name, points: @p2.points + 1)
      end
    end

    def score = ScoreFn.compute(@p1, @p2)
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
