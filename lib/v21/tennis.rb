module TennisKata
  class Player < Struct.new(:name, :points)
    SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

    def initialize(name) = super(name, 0)
    def win_point = self.points += 1
    def score_name = SCORE_NAMES[points]
    def to_s = name
  end

  class TennisGame
    def initialize(name1, name2)
      @player1 = Player.new(name1)
      @player2 = Player.new(name2)
    end

    def won_point(player_name) = find_player(player_name).win_point

    def score
      diff = (p1.points - p2.points).abs
      max = [p1.points, p2.points].max
      leader = p1.points >= p2.points ? p1 : p2

      case [diff, max]
      in [0, ..2] then "#{leader.score_name}-All"
      in [0, 3..] then "Deuce"
      in [1.., ..3] then "#{p1.score_name}-#{p2.score_name}"
      in [1, 4..] then "Advantage #{leader}"
      in [2.., 4..] then "Win for #{leader}"
      end
    end

    private

    def p1 = @player1
    def p2 = @player2
    def find_player(name) = [p1, p2].find { it.name == name }
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
