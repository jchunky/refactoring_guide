module TennisKata
  class Player < Struct.new(:name, :points)
    alias to_s name
    def initialize(name) = super(name, 0)

    def score = %w[Love Fifteen Thirty Forty][points]
    def win_point = self.points += 1
  end

  class TennisGame < Struct.new(:player1, :player2)
    def initialize(player1_name, player2_name)
      super(Player.new(player1_name), Player.new(player2_name))
    end

    def won_point(player_name) = find_player(player_name).win_point

    def score
      case [point_diff, max_points]
      in [0, ..2] then "#{leader.score}-All"
      in [0, 3..] then "Deuce"
      in [1.., ..3] then "#{player1.score}-#{player2.score}"
      in [1, 4..] then "Advantage #{leader}"
      in [2.., 4..] then "Win for #{leader}"
      end
    end

    private

    def find_player(name) = players.find { it.name == name }
    def leader = players.max_by(&:points)
    def max_points = players.map(&:points).max
    def point_diff = players.map(&:points).reduce(&:-).abs
    def players = [player1, player2]
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
