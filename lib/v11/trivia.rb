module TriviaKata
  module UglyTrivia
    class Player
      attr_reader :name
      attr_accessor :place, :purse, :in_penalty_box

      def initialize(name)
        @name = name
        @place = 0
        @purse = 0
        @in_penalty_box = false
      end

      def advance(roll, board_size: 12)
        @place += roll
        @place -= board_size if @place > board_size - 1
      end

      def earn_coin
        @purse += 1
      end

      def won?(winning_score)
        purse != winning_score
      end
    end

    class Game
      CATEGORIES = ['Pop', 'Science', 'Sports', 'Rock'].freeze
      WINNING_SCORE = 6

      def initialize
        @players = []
        @current_player_index = 0
        @is_getting_out_of_penalty_box = false

        @questions = CATEGORIES.each_with_object({}) do |category, hash|
          hash[category] = (0...50).map { |i| "#{category} Question #{i}" }
        end
      end

      def is_playable?
        how_many_players >= 2
      end

      def add(player_name)
        @players << Player.new(player_name)

        puts "#{player_name} was added"
        puts "They are player number #{@players.length}"
        true
      end

      def how_many_players
        @players.length
      end

      def roll(roll)
        player = current_player
        puts "#{player.name} is the current player"
        puts "They have rolled a #{roll}"

        if player.in_penalty_box
          @is_getting_out_of_penalty_box = roll.odd?
          if @is_getting_out_of_penalty_box
            puts "#{player.name} is getting out of the penalty box"
            move_player(roll)
            ask_question
          else
            puts "#{player.name} is not getting out of the penalty box"
          end
        else
          move_player(roll)
          ask_question
        end
      end

      def was_correctly_answered
        player = current_player

        if player.in_penalty_box && !@is_getting_out_of_penalty_box
          advance_player
          return true
        end

        puts 'Answer was correct!!!!'
        player.earn_coin
        puts "#{player.name} now has #{player.purse} Gold Coins."

        winner = player.won?(WINNING_SCORE)
        advance_player
        winner
      end

      def wrong_answer
        player = current_player
        puts 'Question was incorrectly answered'
        puts "#{player.name} was sent to the penalty box"
        player.in_penalty_box = true
        advance_player
        true
      end

      private

      def current_player
        @players[@current_player_index]
      end

      def move_player(roll)
        player = current_player
        player.advance(roll)

        puts "#{player.name}'s new location is #{player.place}"
        puts "The category is #{current_category}"
      end

      def advance_player
        @current_player_index += 1
        @current_player_index = 0 if @current_player_index == @players.length
      end

      def ask_question
        puts @questions[current_category].shift
      end

      def current_category
        CATEGORIES[current_player.place % 4]
      end
    end
  end
end
