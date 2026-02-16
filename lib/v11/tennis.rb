module TennisKata
  SCORE_NAMES = { 0 => "Love", 1 => "Fifteen", 2 => "Thirty", 3 => "Forty" }.freeze

  class Player
    attr_reader :name
    attr_accessor :points

    def initialize(name)
      @name = name
      @points = 0
    end

    def score_name
      SCORE_NAMES[points]
    end
  end

  class TennisGame1
    def initialize(player1_name, player2_name)
      @player1 = Player.new(player1_name)
      @player2 = Player.new(player2_name)
    end

    def won_point(player_name)
      player_for(player_name).points += 1
    end

    def score
      if @player1.points == @player2.points
        return @player1.points >= 3 ? "Deuce" : "#{@player1.score_name}-All"
      end

      if @player1.points >= 4 || @player2.points >= 4
        leader = @player1.points > @player2.points ? @player1 : @player2
        difference = (@player1.points - @player2.points).abs
        return difference == 1 ? "Advantage #{leader.name}" : "Win for #{leader.name}"
      end

      "#{@player1.score_name}-#{@player2.score_name}"
    end

    private

    def player_for(player_name)
      @player1.name == player_name ? @player1 : @player2
    end
  end

  class TennisGame2
    def initialize(player1_name, player2_name)
      @player1 = Player.new(player1_name)
      @player2 = Player.new(player2_name)
    end

    def won_point(player_name)
      player_for(player_name).points += 1
    end

    def score
      if @player1.points == @player2.points
        return @player1.points >= 3 ? "Deuce" : "#{@player1.score_name}-All"
      end

      if @player1.points >= 4 || @player2.points >= 4
        leader = @player1.points > @player2.points ? @player1 : @player2
        difference = (@player1.points - @player2.points).abs
        return difference == 1 ? "Advantage #{leader.name}" : "Win for #{leader.name}"
      end

      "#{@player1.score_name}-#{@player2.score_name}"
    end

    def setp1Score(number)
      (0..number).each { p1Score }
    end

    def setp2Score(number)
      (0..number).each { p2Score }
    end

    def p1Score
      @player1.points += 1
    end

    def p2Score
      @player2.points += 1
    end

    private

    def player_for(player_name)
      @player1.name == player_name ? @player1 : @player2
    end
  end

  class TennisGame3
    def initialize(player1_name, player2_name)
      @player1 = Player.new(player1_name)
      @player2 = Player.new(player2_name)
    end

    def won_point(player_name)
      player_for(player_name).points += 1
    end

    def score
      if @player1.points < 4 && @player2.points < 4 && @player1.points + @player2.points < 6
        return @player1.points == @player2.points ? "#{@player1.score_name}-All" : "#{@player1.score_name}-#{@player2.score_name}"
      end

      return "Deuce" if @player1.points == @player2.points

      leader = @player1.points > @player2.points ? @player1 : @player2
      (@player1.points - @player2.points).abs == 1 ? "Advantage #{leader.name}" : "Win for #{leader.name}"
    end

    private

    def player_for(player_name)
      @player1.name == player_name ? @player1 : @player2
    end
  end
end
