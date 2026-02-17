module TriviaKata
  module UglyTrivia
    # Events
    PlayerAdded = Data.define(:player_name)
    DiceRolled = Data.define(:roll)
    AnsweredCorrectly = Data.define
    AnsweredWrong = Data.define

    # State
    PlayerState = Data.define(:name, :location, :purse, :in_penalty_box)
    QuestionState = Data.define(:indices)

    GameState = Data.define(:players, :current_index, :question_indices) do
      def self.initial = new(players: [], current_index: 0, question_indices: Hash.new(0))

      def current_player = players[current_index]
      def any_winner? = players.any? { it.purse >= 6 }
    end

    CATEGORIES = %w[Pop Science Sports Rock].freeze

    module GameReducer
      def self.category_for(location) = CATEGORIES[location % CATEGORIES.count]

      def self.apply(state, event)
        case event
        in PlayerAdded[player_name:]
          new_player = PlayerState.new(name: player_name, location: 0, purse: 0, in_penalty_box: false)
          state.with(players: state.players + [new_player])

        in DiceRolled[roll:]
          apply_roll(state, roll)

        in AnsweredCorrectly
          apply_correct_answer(state)

        in AnsweredWrong
          apply_wrong_answer(state)
        end
      end

      def self.apply_roll(state, roll)
        player = state.current_player
        if player.in_penalty_box
          if roll.odd?
            player = player.with(in_penalty_box: false)
          else
            players = state.players.dup
            return state
          end
        end

        new_location = (player.location + roll) % 12
        player = player.with(location: new_location)

        category = category_for(new_location)
        new_indices = state.question_indices.dup
        new_indices[category] = (new_indices[category] || 0) + 1

        players = state.players.dup
        players[state.current_index] = player
        state.with(players:, question_indices: new_indices)
      end

      def self.apply_correct_answer(state)
        player = state.current_player
        unless player.in_penalty_box
          player = player.with(purse: player.purse + 1)
          players = state.players.dup
          players[state.current_index] = player
          state = state.with(players:)
        end
        advance(state)
      end

      def self.apply_wrong_answer(state)
        player = state.current_player.with(in_penalty_box: true)
        players = state.players.dup
        players[state.current_index] = player
        advance(state.with(players:))
      end

      def self.advance(state)
        state.with(current_index: (state.current_index + 1) % state.players.count)
      end
    end

    # Output generation from events (separated from state transitions)
    module OutputGenerator
      def self.generate(state_before, event)
        lines = []
        case event
        in PlayerAdded[player_name:]
          lines << "#{player_name} was added"
          lines << "They are player number #{state_before.players.count + 1}"

        in DiceRolled[roll:]
          player = state_before.current_player
          lines << "#{player.name} is the current player"
          lines << "They have rolled a #{roll}"

          if player.in_penalty_box
            if roll.odd?
              lines << "#{player.name} is getting out of the penalty box"
              new_loc = (player.location + roll) % 12
              category = GameReducer.category_for(new_loc)
              qi = state_before.question_indices[category] || 0
              lines << "#{player.name}'s new location is #{new_loc}"
              lines << "The category is #{category}"
              lines << "#{category} Question #{qi}"
            else
              lines << "#{player.name} is not getting out of the penalty box"
            end
          else
            new_loc = (player.location + roll) % 12
            category = GameReducer.category_for(new_loc)
            qi = state_before.question_indices[category] || 0
            lines << "#{player.name}'s new location is #{new_loc}"
            lines << "The category is #{category}"
            lines << "#{category} Question #{qi}"
          end

        in AnsweredCorrectly
          player = state_before.current_player
          unless player.in_penalty_box
            lines << "Answer was correct!!!!"
            lines << "#{player.name} now has #{player.purse + 1} Gold Coins."
          end

        in AnsweredWrong
          player = state_before.current_player
          lines << "Question was incorrectly answered"
          lines << "#{player.name} was sent to the penalty box"
        end
        lines
      end
    end

    class Game
      def initialize
        @state = GameState.initial
      end

      def add(player_name)
        process_event(PlayerAdded.new(player_name:))
      end

      def roll(roll)
        process_event(DiceRolled.new(roll:))
      end

      def was_correctly_answered
        process_event(AnsweredCorrectly.new)
        !@state.any_winner?
      end

      def wrong_answer
        process_event(AnsweredWrong.new)
        !@state.any_winner?
      end

      private

      def process_event(event)
        output = OutputGenerator.generate(@state, event)
        @state = GameReducer.apply(@state, event)
        output.each { puts it }
      end
    end
  end
end
