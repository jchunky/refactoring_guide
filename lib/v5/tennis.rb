module TennisKata
  # Refactored using 99 Bottles of OOP principles:
  # - Extract class for Player concept
  # - Extract class for Score concept
  # - Replace conditionals with polymorphism for score states
  # - Small methods that do one thing
  # - Names reflect roles, not implementation

  class Player
    attr_reader :name
    attr_accessor :points

    def initialize(name)
      @name = name
      @points = 0
    end

    def score_point
      @points += 1
    end

    def score_name
      Score::NAMES.fetch(points, "Forty")
    end
  end

  class Score
    NAMES = {
      0 => "Love",
      1 => "Fifteen",
      2 => "Thirty",
      3 => "Forty"
    }.freeze

    def self.for(player1, player2)
      if player1.points == player2.points
        TiedScore.new(player1, player2)
      elsif player1.points >= 4 || player2.points >= 4
        EndgameScore.new(player1, player2)
      else
        NormalScore.new(player1, player2)
      end
    end

    def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
    end

    private

    attr_reader :player1, :player2

    def leading_player
      player1.points > player2.points ? player1 : player2
    end

    def point_difference
      (player1.points - player2.points).abs
    end
  end

  class TiedScore < Score
    def to_s
      return "Deuce" if player1.points >= 3
      "#{player1.score_name}-All"
    end
  end

  class EndgameScore < Score
    def to_s
      return "Win for #{leading_player.name}" if point_difference >= 2
      "Advantage #{leading_player.name}"
    end
  end

  class NormalScore < Score
    def to_s
      "#{player1.score_name}-#{player2.score_name}"
    end
  end

  class TennisGame1
    def initialize(player1_name, player2_name)
      @player1 = Player.new(player1_name)
      @player2 = Player.new(player2_name)
    end

    def won_point(player_name)
      player_for(player_name).score_point
    end

    def score
      Score.for(@player1, @player2).to_s
    end

    private

    def player_for(name)
      name == @player1.name ? @player1 : @player2
    end
  end

  class TennisGame2
    def initialize(player1_name, player2_name)
      @player1 = Player.new(player1_name)
      @player2 = Player.new(player2_name)
    end

    def won_point(player_name)
      player_for(player_name).score_point
    end

    def score
      Score.for(@player1, @player2).to_s
    end

    def setp1Score(number)
      (0..number).each { p1Score }
    end

    def setp2Score(number)
      (0..number).each { p2Score }
    end

    def p1Score
      @player1.score_point
    end

    def p2Score
      @player2.score_point
    end

    private

    def player_for(name)
      name == @player1.name ? @player1 : @player2
    end
  end

  class TennisGame3
    def initialize(player1_name, player2_name)
      @player1 = Player.new(player1_name)
      @player2 = Player.new(player2_name)
    end

    def won_point(player_name)
      player_for(player_name).score_point
    end

    def score
      Score.for(@player1, @player2).to_s
    end

    private

    def player_for(name)
      name == @player1.name ? @player1 : @player2
    end
  end
end
