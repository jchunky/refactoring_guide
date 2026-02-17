module TennisKata
  SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

  # Declarative score rules: [condition_lambda, result_lambda]
  # Evaluated in order; first match wins
  SCORE_RULES = [
    [->(d, m, **_) { d == 0 && m <= 2 }, ->(p1:, **_) { "#{SCORE_NAMES[p1]}-All" }],
    [->(d, m, **_) { d == 0 && m >= 3 }, ->(**_) { "Deuce" }],
    [->(d, m, **_) { d >= 1 && m <= 3 }, ->(p1:, p2:, **_) { "#{SCORE_NAMES[p1]}-#{SCORE_NAMES[p2]}" }],
    [->(d, m, **_) { d == 1 && m >= 4 }, ->(leader:, **_) { "Advantage #{leader}" }],
    [->(d, m, **_) { d >= 2 && m >= 4 }, ->(leader:, **_) { "Win for #{leader}" }],
  ].freeze

  class Player < Struct.new(:name, :points)
    def initialize(name) = super(name, 0)
    def win_point = self.points += 1
  end

  class TennisGame
    def initialize(name1, name2)
      @player1 = Player.new(name1)
      @player2 = Player.new(name2)
    end

    def won_point(player_name) = find_player(player_name).win_point

    def score
      p1 = @player1.points
      p2 = @player2.points
      diff = (p1 - p2).abs
      max = [p1, p2].max
      leader = p1 >= p2 ? @player1.name : @player2.name

      _, result_fn = SCORE_RULES.find { |cond, _| cond.call(diff, max) }
      result_fn.call(p1:, p2:, leader:)
    end

    private

    def find_player(name) = [@player1, @player2].find { it.name == name }
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
