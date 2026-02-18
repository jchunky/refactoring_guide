module TriviaKata
  # ═══════════════════════════════════════════════════════════════
  # FUNCTIONAL CORE
  #
  # Pure state machine. No I/O, no mutation, no side effects.
  # Each function takes a game state and returns a new state plus
  # an array of message strings. The Shell handles all output.
  # ═══════════════════════════════════════════════════════════════

  module Core
    CATEGORIES = %w[Pop Science Sports Rock].freeze
    BOARD_SIZE = 12
    WINNING_SCORE = 6

    def self.category_for(place) = CATEGORIES[place % 4]

    def self.question_text(category, index) = "#{category} Question #{index}"

    def self.new_state
      {
        players: [],
        places: [],
        purses: [],
        in_penalty_box: [],
        current_player: 0,
        is_getting_out: false,
        question_counts: { "Pop" => 0, "Science" => 0, "Sports" => 0, "Rock" => 0 }
      }
    end

    def self.add_player(state, name)
      players = state[:players] + [name]
      messages = [
        "#{name} was added",
        "They are player number #{players.length}"
      ]
      new_state = state.merge(
        players: players,
        places: state[:places] + [0],
        purses: state[:purses] + [0],
        in_penalty_box: state[:in_penalty_box] + [false]
      )
      [new_state, messages]
    end

    def self.roll(state, roll_value)
      cp = state[:current_player]
      name = state[:players][cp]
      messages = [
        "#{name} is the current player",
        "They have rolled a #{roll_value}"
      ]

      if state[:in_penalty_box][cp]
        if roll_value.odd?
          messages << "#{name} is getting out of the penalty box"
          new_state, move_messages = move_and_ask(state, cp, roll_value)
          [new_state.merge(is_getting_out: true), messages + move_messages]
        else
          messages << "#{name} is not getting out of the penalty box"
          [state.merge(is_getting_out: false), messages]
        end
      else
        new_state, move_messages = move_and_ask(state, cp, roll_value)
        [new_state, messages + move_messages]
      end
    end

    def self.correct_answer(state)
      cp = state[:current_player]

      if state[:in_penalty_box][cp] && !state[:is_getting_out]
        [advance_player(state), [], true]
      else
        purses = state[:purses].dup
        purses[cp] += 1
        name = state[:players][cp]
        messages = [
          "Answer was correct!!!!",
          "#{name} now has #{purses[cp]} Gold Coins."
        ]
        still_playing = purses[cp] != WINNING_SCORE
        new_state = advance_player(state.merge(purses: purses))
        [new_state, messages, still_playing]
      end
    end

    def self.wrong_answer(state)
      cp = state[:current_player]
      name = state[:players][cp]
      penalty = state[:in_penalty_box].dup
      penalty[cp] = true
      messages = [
        "Question was incorrectly answered",
        "#{name} was sent to the penalty box"
      ]
      new_state = advance_player(state.merge(in_penalty_box: penalty))
      [new_state, messages, true]
    end

    # ── Private helpers ──────────────────────────────────────────

    def self.move_and_ask(state, cp, roll_value)
      new_place = (state[:places][cp] + roll_value) % BOARD_SIZE
      places = state[:places].dup
      places[cp] = new_place

      category = category_for(new_place)
      q_counts = state[:question_counts].dup
      q_index = q_counts[category]
      q_counts[category] = q_index + 1

      name = state[:players][cp]
      messages = [
        "#{name}'s new location is #{new_place}",
        "The category is #{category}",
        question_text(category, q_index)
      ]

      [state.merge(places: places, question_counts: q_counts), messages]
    end
    private_class_method :move_and_ask

    def self.advance_player(state)
      next_player = (state[:current_player] + 1) % state[:players].length
      state.merge(current_player: next_player)
    end
    private_class_method :advance_player
  end

  # ═══════════════════════════════════════════════════════════════
  # IMPERATIVE SHELL
  #
  # Thin wrapper that maintains mutable state and handles all I/O.
  # Each method delegates to the Core, updates @state, and prints
  # the messages. Contains no game logic of its own.
  # ═══════════════════════════════════════════════════════════════

  module UglyTrivia
    class Game
      def initialize
        @state = Core.new_state
      end

      def is_playable?
        @state[:players].length >= 2
      end

      def how_many_players
        @state[:players].length
      end

      def add(player_name)
        @state, messages = Core.add_player(@state, player_name)
        messages.each { |m| puts m }
        true
      end

      def roll(roll_value)
        @state, messages = Core.roll(@state, roll_value)
        messages.each { |m| puts m }
      end

      def was_correctly_answered
        @state, messages, still_playing = Core.correct_answer(@state)
        messages.each { |m| puts m }
        still_playing
      end

      def wrong_answer
        @state, messages, still_playing = Core.wrong_answer(@state)
        messages.each { |m| puts m }
        still_playing
      end
    end
  end
end
