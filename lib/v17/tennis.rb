module TennisKata
  class Player
    SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

    def initialize(name)
      @name = name
      @points = 0
    end

    def receive(message, *args)
      case message
      in :win_point then @points += 1
      in :points then @points
      in :name then @name
      in :score_name then SCORE_NAMES[@points]
      in :to_s then @name
      end
    end
  end

  class TennisGame
    def initialize(name1, name2)
      @player1 = Player.new(name1)
      @player2 = Player.new(name2)
    end

    def won_point(player_name)
      find_player(player_name).receive(:win_point)
    end

    def score
      p1_pts = @player1.receive(:points)
      p2_pts = @player2.receive(:points)
      diff = (p1_pts - p2_pts).abs
      max = [p1_pts, p2_pts].max
      leader = p1_pts >= p2_pts ? @player1 : @player2

      case [diff, max]
      in [0, ..2] then "#{leader.receive(:score_name)}-All"
      in [0, 3..] then "Deuce"
      in [1.., ..3] then "#{@player1.receive(:score_name)}-#{@player2.receive(:score_name)}"
      in [1, 4..] then "Advantage #{leader.receive(:name)}"
      in [2.., 4..] then "Win for #{leader.receive(:name)}"
      end
    end

    private

    def find_player(name)
      [@player1, @player2].find { it.receive(:name) == name }
    end
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
