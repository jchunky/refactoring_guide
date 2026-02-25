# frozen_string_literal: true

module TennisKata
  SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

  class Player < Struct.new(:name, :points)
    def initialize(name) = super(name, 0)

    def to_s = name
    def score = SCORE_NAMES[points]
  end

  class TennisGame < Struct.new(:player1, :player2)
    def initialize(name1, name2) = super(Player.new(name1), Player.new(name2))

    def won_point(name) = find_player(name).points += 1

    def score
      if player1.points == player2.points
        return player1.points >= 3 ? "Deuce" : "#{leader.score}-All"
      end

      if player1.points >= 4 || player2.points >= 4
        difference = player1.points - player2.points
        return difference.abs >= 2 ? "Win for #{leader}" : "Advantage #{leader}"
      end

      "#{player1.score}-#{player2.score}"
    end

    private

    def leader = players.max_by(&:points)
    def find_player(name) = players.find { it.name == name }
    def players = [player1, player2]
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
