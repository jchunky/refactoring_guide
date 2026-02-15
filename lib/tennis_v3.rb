class Player < Struct.new(:name, :points)
  alias to_s name

  def score_point = self.points += 1

  def score_name
    case points
    in 0 then "Love"
    in 1 then "Fifteen"
    in 2 then "Thirty"
    in 3 then "Forty"
    end
  end
end

class TennisGame1
  def initialize(player1_name, player2_name)
    @player1 = Player.new(player1_name, 0)
    @player2 = Player.new(player2_name, 0)
  end

  def won_point(player_name)
    player_name == @player1.name ? @player1.score_point : @player2.score_point
  end

  def score
    case [@player1.points, @player2.points]
    in [p1, p2] if p1 == p2 && p1 < 3
      "#{@player1.score_name}-All"
    in [p1, p2] if p1 == p2
      "Deuce"
    in [p1, p2] if p1 >= 4 || p2 >= 4
      leader, diff = p1 > p2 ? [@player1, p1 - p2] : [@player2, p2 - p1]
      diff == 1 ? "Advantage #{leader}" : "Win for #{leader}"
    else
      "#{@player1.score_name}-#{@player2.score_name}"
    end
  end
end

class TennisGame2
  def initialize(player1_name, player2_name)
    @player1 = Player.new(player1_name, 0)
    @player2 = Player.new(player2_name, 0)
  end

  def won_point(player_name)
    player_name == @player1.name ? p1Score : p2Score
  end

  def score
    case [@player1.points, @player2.points]
    in [p1, p2] if p1 == p2 && p1 < 3
      "#{@player1.score_name}-All"
    in [p1, p2] if p1 == p2
      "Deuce"
    in [p1, p2] if [p1, p2].max >= 4
      leader, diff = p1 > p2 ? [@player1, p1 - p2] : [@player2, p2 - p1]
      diff >= 2 ? "Win for #{leader}" : "Advantage #{leader}"
    else
      "#{@player1.score_name}-#{@player2.score_name}"
    end
  end

  def setp1Score(number) = (0..number).each { p1Score }
  def setp2Score(number) = (0..number).each { p2Score }
  def p1Score = @player1.score_point
  def p2Score = @player2.score_point
end

class TennisGame3
  SCORE_NAMES = ["Love", "Fifteen", "Thirty", "Forty"].freeze

  def initialize(player1_name, player2_name)
    @player1 = Player.new(player1_name, 0)
    @player2 = Player.new(player2_name, 0)
  end

  def won_point(name)
    name == @player1.name ? @player1.score_point : @player2.score_point
  end

  def score
    p1, p2 = @player1.points, @player2.points

    return tied_score(p1) if p1 == p2
    return regular_score(p1, p2) if p1 < 4 && p2 < 4 && p1 + p2 < 6

    endgame_score(p1, p2)
  end

  private

  def tied_score(points) = points >= 3 ? "Deuce" : "#{SCORE_NAMES[points]}-All"

  def regular_score(p1, p2) = "#{SCORE_NAMES[p1]}-#{SCORE_NAMES[p2]}"

  def endgame_score(p1, p2)
    leader = p1 > p2 ? @player1 : @player2
    diff = (p1 - p2).abs
    diff == 1 ? "Advantage #{leader}" : "Win for #{leader}"
  end
end
