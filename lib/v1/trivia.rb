# frozen_string_literal: true

module TriviaKata
  module UglyTrivia
    class Player < Struct.new(:name, :place, :purse, :in_penalty_box)
      def initialize(name) = super(name, 0, 0, false)

      def receive_winnings = self.purse += 1
      def enter_penalty_box = self.in_penalty_box = true
      def leave_penalty_box = self.in_penalty_box = false
      def advance(roll) = self.place = (place + roll) % Game::BOARD_SIZE

      def to_s = name
      def winner? = purse >= Game::WINNING_PURSE
    end

    class Game
      CATEGORIES = %w[Pop Science Sports Rock].freeze
      BOARD_SIZE = 12
      WINNING_PURSE = 6

      def initialize
        @players = []
        @questions = CATEGORIES.to_h { [it, 0] }
      end

      def add(player_name)
        @players << Player.new(player_name)
        puts "#{player_name} was added"
        puts "They are player number #{@players.count}"
        true
      end

      def roll(roll)
        puts "#{current_player} is the current player"
        puts "They have rolled a #{roll}"

        check_whether_leaving_penalty_box(roll)
        return if current_player.in_penalty_box

        move_player(current_player, roll)
        ask_question
      end

      def was_correctly_answered
        unless current_player.in_penalty_box
          puts "Answer was correct!!!!"
          current_player.receive_winnings
          puts "#{current_player} now has #{current_player.purse} Gold Coins."
        end
        advance_turn
      end

      def wrong_answer
        puts "Question was incorrectly answered"
        puts "#{current_player} was sent to the penalty box"
        current_player.enter_penalty_box
        advance_turn
      end

      private

      def check_whether_leaving_penalty_box(roll)
        return unless current_player.in_penalty_box

        if roll.odd?
          puts "#{current_player} is getting out of the penalty box"
          current_player.leave_penalty_box
        else
          puts "#{current_player} is not getting out of the penalty box"
        end
      end

      def advance_turn
        @players.rotate!
        @players.none?(&:winner?)
      end

      def move_player(player, roll)
        player.advance(roll)
        puts "#{player.name}'s new location is #{player.place}"
        puts "The category is #{current_category}"
      end

      def ask_question
        index = @questions[current_category]
        @questions[current_category] += 1
        puts "#{current_category} Question #{index}"
      end

      def current_category = CATEGORIES[current_player.place % CATEGORIES.length]
      def current_player = @players.first
    end
  end
end
