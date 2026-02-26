# frozen_string_literal: true

module TennisKata
  SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

  class Player < Struct.new(:name, :points)
    def initialize(name) = super(name, 0)

    def win_point = self.points += 1

    def to_s = name
    def score = SCORE_NAMES[points]
  end

  class TennisGame < Struct.new(:player1, :player2)
    def initialize(name1, name2) = super(Player.new(name1), Player.new(name2))

    def won_point(name) = find_player(name).win_point

    def score
      case [point_diff, max_points]
      in [0, 3..] then "Deuce"
      in [0, ..2] then "#{leader.score}-All"
      in [2.., 4..] then "Win for #{leader}"
      in [1, 4..] then "Advantage #{leader}"
      in [1.., ..3] then "#{player1.score}-#{player2.score}"
      end
    end

    private

    def max_points = players.map(&:points).max
    def point_diff = players.map(&:points).reduce(&:-).abs
    def leader = players.max_by(&:points)
    def find_player(name) = players.find { it.name == name }
    def players = [player1, player2]
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
