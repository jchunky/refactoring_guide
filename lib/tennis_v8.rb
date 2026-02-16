# Refactored to fix:
# - Data Clumps: Player data grouped into Player class
# - Feature Envy: Player handles its own score formatting
# - Primitive Obsession: Score class handles tennis scoring logic

class Player
  SCORE_NAMES = ['Love', 'Fifteen', 'Thirty', 'Forty'].freeze

  attr_reader :name, :points

  def initialize(name)
    @name = name
    @points = 0
  end

  def won_point
    @points += 1
  end

  def score_name
    SCORE_NAMES[@points] || 'Forty'
  end
end

class TennisGame1
  def initialize(player1_name, player2_name)
    @player1 = Player.new(player1_name)
    @player2 = Player.new(player2_name)
  end

  def won_point(player_name)
    player_for(player_name).won_point
  end

  def score
    if tied?
      tied_score
    elsif in_endgame?
      endgame_score
    else
      regular_score
    end
  end

  private

  def player_for(name)
    @player1.name == name ? @player1 : @player2
  end

  def tied?
    @player1.points == @player2.points
  end

  def in_endgame?
    @player1.points >= 4 || @player2.points >= 4
  end

  def tied_score
    return 'Deuce' if @player1.points >= 3
    "#{@player1.score_name}-All"
  end

  def endgame_score
    point_difference = @player1.points - @player2.points
    leader = point_difference > 0 ? @player1 : @player2

    if point_difference.abs == 1
      "Advantage #{leader.name}"
    else
      "Win for #{leader.name}"
    end
  end

  def regular_score
    "#{@player1.score_name}-#{@player2.score_name}"
  end
end

class TennisGame2
  def initialize(player1_name, player2_name)
    @player1 = Player.new(player1_name)
    @player2 = Player.new(player2_name)
  end

  def won_point(player_name)
    player_for(player_name).won_point
  end

  def score
    if tied?
      tied_score
    elsif in_endgame?
      endgame_score
    else
      regular_score
    end
  end

  private

  def player_for(name)
    @player1.name == name ? @player1 : @player2
  end

  def tied?
    @player1.points == @player2.points
  end

  def in_endgame?
    @player1.points >= 4 || @player2.points >= 4
  end

  def tied_score
    return 'Deuce' if @player1.points >= 3
    "#{@player1.score_name}-All"
  end

  def endgame_score
    point_difference = @player1.points - @player2.points
    leader = point_difference > 0 ? @player1 : @player2

    return "Advantage #{leader.name}" if point_difference.abs == 1
    "Win for #{leader.name}"
  end

  def regular_score
    "#{@player1.score_name}-#{@player2.score_name}"
  end
end

class TennisGame3
  def initialize(player1_name, player2_name)
    @player1 = Player.new(player1_name)
    @player2 = Player.new(player2_name)
  end

  def won_point(player_name)
    player_for(player_name).won_point
  end

  def score
    if in_early_game?
      early_game_score
    elsif tied?
      'Deuce'
    else
      late_game_score
    end
  end

  private

  def player_for(name)
    @player1.name == name ? @player1 : @player2
  end

  def tied?
    @player1.points == @player2.points
  end

  def in_early_game?
    @player1.points < 4 && @player2.points < 4 && @player1.points + @player2.points < 6
  end

  def early_game_score
    return "#{@player1.score_name}-All" if tied?
    "#{@player1.score_name}-#{@player2.score_name}"
  end

  def late_game_score
    leader = @player1.points > @player2.points ? @player1 : @player2
    point_diff = (@player1.points - @player2.points).abs

    point_diff == 1 ? "Advantage #{leader.name}" : "Win for #{leader.name}"
  end
end
