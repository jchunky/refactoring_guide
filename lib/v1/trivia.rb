module TriviaKata
  module UglyTrivia
    class Player
      attr_reader :name
      attr_accessor :place, :purse, :in_penalty_box, :getting_out

      def initialize(name)
        @name = name
        @place = 0
        @purse = 0
        @in_penalty_box = false
        @getting_out = false
      end

      def advance(roll)
        @place = (@place + roll) % 12
      end

      def earn_coin
        @purse += 1
      end

      def won?
        @purse == 6
      end
    end

    class Game
      CATEGORIES = %w[Pop Science Sports Rock].freeze
      BOARD_SIZE = 12

      def initialize
        @players = []
        @current_player_index = 0
        @questions = CATEGORIES.each_with_object({}) do |category, hash|
          hash[category] = (0...50).map { |i| "#{category} Question #{i}" }
        end
      end

      def is_playable?
        @players.size >= 2
      end

      def add(player_name)
        @players << Player.new(player_name)

        puts "#{player_name} was added"
        puts "They are player number #{@players.size}"

        true
      end

      def how_many_players
        @players.size
      end

      def roll(roll)
        player = current_player
        puts "#{player.name} is the current player"
        puts "They have rolled a #{roll}"

        if player.in_penalty_box
          if roll.odd?
            player.getting_out = true
            puts "#{player.name} is getting out of the penalty box"
            move_and_ask_question(player, roll)
          else
            puts "#{player.name} is not getting out of the penalty box"
            player.getting_out = false
          end
        else
          move_and_ask_question(player, roll)
        end
      end

      def was_correctly_answered
        player = current_player

        if player.in_penalty_box && !player.getting_out
          advance_turn
          return true
        end

        puts 'Answer was correct!!!!'
        player.earn_coin
        puts "#{player.name} now has #{player.purse} Gold Coins."

        winner = !player.won?
        advance_turn
        winner
      end

      def wrong_answer
        player = current_player
        puts 'Question was incorrectly answered'
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
        @current_player_index = (@current_player_index + 1) % @players.size
      end

      def move_and_ask_question(player, roll)
        player.advance(roll)
        puts "#{player.name}'s new location is #{player.place}"
        puts "The category is #{current_category}"
        ask_question
      end

      def current_category
        CATEGORIES[current_player.place % CATEGORIES.size]
      end

      def ask_question
        puts @questions[current_category].shift
      end
    end
  end
end
