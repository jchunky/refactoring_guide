# frozen_string_literal: true

module TriviaKata
  module UglyTrivia
    class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
      def initialize(name) = super(name, 0, 0, false)

      def to_s = name
    end

    class Game < Struct.new(:players)
      BOARD_SIZE = 12
      WINNING_SCORE = 6
      CATEGORIES = %w[Pop Science Sports Rock].freeze
      QUESTIONS_PER_CATEGORY = 50

      def initialize
        super([])
        @is_getting_out_of_penalty_box = false

        @questions = CATEGORIES.each_with_object({}) do |category, hash|
          hash[category] = Array.new(QUESTIONS_PER_CATEGORY) { |i| "#{category} Question #{i}" }
        end
      end

      def is_playable?
        how_many_players >= 2
      end

      def add(player_name)
        players << Player.new(player_name)

        puts "#{player_name} was added"
        puts "They are player number #{players.count}"
      end

      def roll(roll)
        puts "#{current_player} is the current player"
        puts "They have rolled a #{roll}"

        if current_player.in_penalty_box
          if roll.odd?
            @is_getting_out_of_penalty_box = true
            puts "#{current_player} is getting out of the penalty box"
            move_player(roll)
            ask_question
          else
            puts "#{current_player} is not getting out of the penalty box"
            @is_getting_out_of_penalty_box = false
          end
        else
          move_player(roll)
          ask_question
        end
      end

      def was_correctly_answered
        unless current_player.in_penalty_box && !@is_getting_out_of_penalty_box
          puts "Answer was correct!!!!"
          current_player.purse += 1
          puts "#{current_player} now has #{current_player.purse} Gold Coins."
        end

        advance_player
        !winner?
      end

      def wrong_answer
        puts "Question was incorrectly answered"
        puts "#{current_player} was sent to the penalty box"
        current_player.in_penalty_box = true

        advance_player
        !winner?
      end

      private

      def current_player
        players.first
      end

      def move_player(roll)
        current_player.location += roll
        current_player.location -= BOARD_SIZE if current_player.location > (BOARD_SIZE - 1)

        puts "#{current_player}'s new location is #{current_player.location}"
        puts "The category is #{current_category}"
      end

      def ask_question
        puts @questions[current_category].shift
      end

      def current_category
        CATEGORIES[current_player.location % CATEGORIES.size]
      end

      def advance_player
        players.rotate!
      end

      def winner?
        current_player.purse == WINNING_SCORE
      end
    end
  end
end
