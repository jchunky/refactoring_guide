# Tennis scoring with polymorphism - no else, no case, 5 lines max
class TennisGame1
  def initialize(player1_name, player2_name)
    @player1 = Player.new(player1_name)
    @player2 = Player.new(player2_name)
  end

  def won_point(player_name)
    player_for(player_name).score_point
  end

  def score
    ScoreReporter.for(@player1, @player2).report
  end

  private

  def player_for(name)
    return @player1 if @player1.name == name
    @player2
  end
end

class Player
  attr_reader :name, :points

  def initialize(name)
    @name = name
    @points = 0
  end

  def score_point = @points += 1
end

class ScoreReporter
  SCORE_NAMES = ["Love", "Fifteen", "Thirty", "Forty"].freeze

  def self.for(player1, player2)
    return DeuceReporter.new(player1, player2) if deuce?(player1, player2)
    return TieReporter.new(player1, player2) if tied?(player1, player2)
    return EndgameReporter.new(player1, player2) if endgame?(player1, player2)
    NormalReporter.new(player1, player2)
  end

  def self.deuce?(p1, p2) = p1.points >= 3 && p1.points == p2.points
  def self.tied?(p1, p2) = p1.points == p2.points
  def self.endgame?(p1, p2) = p1.points >= 4 || p2.points >= 4

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def leader
    return @player1 if @player1.points > @player2.points
    @player2
  end

  def point_difference = (@player1.points - @player2.points).abs
end

class DeuceReporter < ScoreReporter
  def report = "Deuce"
end

class TieReporter < ScoreReporter
  def report = "#{SCORE_NAMES[@player1.points]}-All"
end

class EndgameReporter < ScoreReporter
  def report
    return "Advantage #{leader.name}" if point_difference == 1
    "Win for #{leader.name}"
  end
end

class NormalReporter < ScoreReporter
  def report
    "#{SCORE_NAMES[@player1.points]}-#{SCORE_NAMES[@player2.points]}"
  end
end

# TennisGame2 - refactored version
class TennisGame2
  def initialize(player1_name, player2_name)
    @player1 = Player.new(player1_name)
    @player2 = Player.new(player2_name)
  end

  def won_point(player_name)
    player_for(player_name).score_point
  end

  def score
    ScoreReporter.for(@player1, @player2).report
  end

  def setp1Score(number) = (0..number).each { p1Score }
  def setp2Score(number) = (0..number).each { p2Score }
  def p1Score = @player1.score_point
  def p2Score = @player2.score_point

  private

  def player_for(name)
    return @player1 if @player1.name == name
    @player2
  end
end

# TennisGame3 - refactored version
class TennisGame3
  def initialize(player1_name, player2_name)
    @player1 = Player.new(player1_name)
    @player2 = Player.new(player2_name)
  end

  def won_point(player_name)
    player_for(player_name).score_point
  end

  def score
    ScoreReporter.for(@player1, @player2).report
  end

  private

  def player_for(name)
    return @player1 if @player1.name == name
    @player2
  end
end
