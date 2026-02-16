module TriviaKata
  module UglyTrivia
    class Game
      CATEGORIES = ['Pop', 'Science', 'Sports', 'Rock'].freeze
      WINNING_SCORE = 6

      def initialize
        @players = []
        @places = Array.new(6, 0)
        @purses = Array.new(6, 0)
        @in_penalty_box = Array.new(6, false)
        @current_player = 0
        @is_getting_out_of_penalty_box = false

        @questions = CATEGORIES.each_with_object({}) do |category, hash|
          hash[category] = (0...50).map { |i| "#{category} Question #{i}" }
        end
      end

      def is_playable?
        how_many_players >= 2
      end

      def add(player_name)
        @players.push player_name
        @places[how_many_players] = 0
        @purses[how_many_players] = 0
        @in_penalty_box[how_many_players] = false

        puts "#{player_name} was added"
        puts "They are player number #{@players.length}"
        true
      end

      def how_many_players
        @players.length
      end

      def roll(roll)
        puts "#{current_player_name} is the current player"
        puts "They have rolled a #{roll}"

        if @in_penalty_box[@current_player]
          @is_getting_out_of_penalty_box = roll.odd?
          if @is_getting_out_of_penalty_box
            puts "#{current_player_name} is getting out of the penalty box"
            move_player(roll)
            ask_question
          else
            puts "#{current_player_name} is not getting out of the penalty box"
          end
        else
          move_player(roll)
          ask_question
        end
      end

      def was_correctly_answered
        if @in_penalty_box[@current_player] && !@is_getting_out_of_penalty_box
          advance_player
          return true
        end

        puts 'Answer was correct!!!!'
        @purses[@current_player] += 1
        puts "#{current_player_name} now has #{@purses[@current_player]} Gold Coins."

        winner = did_player_win
        advance_player
        winner
      end

      def wrong_answer
        puts 'Question was incorrectly answered'
        puts "#{current_player_name} was sent to the penalty box"
        @in_penalty_box[@current_player] = true
        advance_player
        true
      end

      private

      def current_player_name
        @players[@current_player]
      end

      def move_player(roll)
        @places[@current_player] += roll
        @places[@current_player] -= 12 if @places[@current_player] > 11

        puts "#{current_player_name}'s new location is #{@places[@current_player]}"
        puts "The category is #{current_category}"
      end

      def advance_player
        @current_player += 1
        @current_player = 0 if @current_player == @players.length
      end

      def ask_question
        puts @questions[current_category].shift
      end

      def current_category
        CATEGORIES[@places[@current_player] % 4]
      end

      def did_player_win
        @purses[@current_player] != WINNING_SCORE
      end
    end
  end
end
