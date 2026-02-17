module TennisKata
  SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

  module ScorePipeline
    def self.classify(p1, p2)
      { p1:, p2:, diff: (p1 - p2).abs, max: [p1, p2].max }
    end

    def self.find_leader(data, p1_name, p2_name)
      data.merge(leader: data[:p1] >= data[:p2] ? p1_name : p2_name)
    end

    def self.format_score(data)
      case [data[:diff], data[:max]]
      in [0, ..2] then "#{SCORE_NAMES[data[:p1]]}-All"
      in [0, 3..] then "Deuce"
      in [1.., ..3] then "#{SCORE_NAMES[data[:p1]]}-#{SCORE_NAMES[data[:p2]]}"
      in [1, 4..] then "Advantage #{data[:leader]}"
      in [2.., 4..] then "Win for #{data[:leader]}"
      end
    end

    def self.compute(p1_points, p2_points, p1_name, p2_name)
      classify(p1_points, p2_points)
        .then { find_leader(it, p1_name, p2_name) }
        .then { format_score(it) }
    end
  end

  class TennisGame
    def initialize(name1, name2)
      @p1_name = name1
      @p2_name = name2
      @p1_points = 0
      @p2_points = 0
    end

    def won_point(player_name)
      player_name == @p1_name ? @p1_points += 1 : @p2_points += 1
    end

    def score = ScorePipeline.compute(@p1_points, @p2_points, @p1_name, @p2_name)
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
