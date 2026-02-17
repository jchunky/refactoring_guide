module TennisKata
  # Events
  PointScored = Data.define(:player_name)

  # State
  GameState = Data.define(:p1_name, :p2_name, :p1_points, :p2_points)

  SCORE_NAMES = %w[Love Fifteen Thirty Forty].freeze

  module GameReducer
    def self.initial(p1_name, p2_name)
      GameState.new(p1_name:, p2_name:, p1_points: 0, p2_points: 0)
    end

    def self.apply(state, event)
      case event
      in PointScored[player_name:] if player_name == state.p1_name
        state.with(p1_points: state.p1_points + 1)
      in PointScored
        state.with(p2_points: state.p2_points + 1)
      end
    end

    def self.score(state)
      diff = (state.p1_points - state.p2_points).abs
      max = [state.p1_points, state.p2_points].max
      leader_name = state.p1_points >= state.p2_points ? state.p1_name : state.p2_name

      case [diff, max]
      in [0, ..2] then "#{SCORE_NAMES[state.p1_points]}-All"
      in [0, 3..] then "Deuce"
      in [1.., ..3] then "#{SCORE_NAMES[state.p1_points]}-#{SCORE_NAMES[state.p2_points]}"
      in [1, 4..] then "Advantage #{leader_name}"
      in [2.., 4..] then "Win for #{leader_name}"
      end
    end
  end

  class TennisGame
    def initialize(name1, name2)
      @events = []
      @initial_state = GameReducer.initial(name1, name2)
    end

    def won_point(player_name)
      @events << PointScored.new(player_name:)
    end

    def score
      state = @events.reduce(@initial_state) { |s, e| GameReducer.apply(s, e) }
      GameReducer.score(state)
    end
  end

  class TennisGame1 < TennisGame; end
  class TennisGame2 < TennisGame; end
  class TennisGame3 < TennisGame; end
end
