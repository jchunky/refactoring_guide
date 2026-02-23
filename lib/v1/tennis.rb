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

    def won_point(player_name) = find_player(player_name).win_point

    def score
      case [max_points, point_diff]
      in [3.., 0] then "Deuce"
      in [..2, 0] then "#{leader.score}-All"
      in [4.., 1] then "Advantage #{leader}"
      in [4.., 2..] then "Win for #{leader}"
      in [..3, 1..] then "#{player1.score}-#{player2.score}"
      end
    end

    private

    def find_player(name) = players.find { it.name == name }
    def point_diff = players.map(&:points).reduce(&:-).abs
    def max_points = players.map(&:points).max
    def leader = players.max_by(&:points)
    def players = [player1, player2]
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
