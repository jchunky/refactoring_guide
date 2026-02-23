# frozen_string_literal: true

module TriviaKata
  module UglyTrivia
    class Player < Struct.new(:name, :place, :purse, :in_penalty_box)
      def initialize(name)
        super(name, 0, 0, false)
      end
    end

    class Game
      CATEGORIES = %w[Pop Science Sports Rock].freeze
      BOARD_SIZE = 12
      WINNING_PURSE = 6

      def initialize
        @players = []
        @current_player_index = 0
        @is_getting_out_of_penalty_box = false
        @questions = CATEGORIES.each_with_object({}) do |category, hash|
          hash[category] = (0...50).map { |i| "#{category} Question #{i}" }
        end
      end

      def is_playable?
        @players.length >= 2
      end

      def add(player_name)
        @players << Player.new(player_name)
        puts "#{player_name} was added"
        puts "They are player number #{@players.length}"
        true
      end

      def roll(roll)
        player = current_player
        puts "#{player.name} is the current player"
        puts "They have rolled a #{roll}"

        if player.in_penalty_box
          if roll.odd?
            @is_getting_out_of_penalty_box = true
            puts "#{player.name} is getting out of the penalty box"
            move_player(player, roll)
            ask_question
          else
            puts "#{player.name} is not getting out of the penalty box"
            @is_getting_out_of_penalty_box = false
          end
        else
          move_player(player, roll)
          ask_question
        end
      end

      def was_correctly_answered
        player = current_player

        if player.in_penalty_box && !@is_getting_out_of_penalty_box
          advance_turn
          return true
        end

        puts "Answer was correct!!!!"
        player.purse += 1
        puts "#{player.name} now has #{player.purse} Gold Coins."

        winner = player.purse != WINNING_PURSE
        advance_turn
        winner
      end

      def wrong_answer
        player = current_player
        puts "Question was incorrectly answered"
        puts "#{player.name} was sent to the penalty box"
        player.in_penalty_box = true
        advance_turn
        true
      end

      private

      def current_player
        @players[@current_player_index]
      end

      def advance_turn
        @current_player_index = (@current_player_index + 1) % @players.length
      end

      def move_player(player, roll)
        player.place = (player.place + roll) % BOARD_SIZE
        puts "#{player.name}'s new location is #{player.place}"
        puts "The category is #{current_category}"
      end

      def current_category
        CATEGORIES[current_player.place % CATEGORIES.length]
      end

      def ask_question
        puts @questions[current_category].shift
      end
    end
  end
end
