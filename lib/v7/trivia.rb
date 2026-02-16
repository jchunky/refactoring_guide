module TriviaKata
  module UglyTrivia
    class Game
      CATEGORIES = ['Pop', 'Science', 'Sports', 'Rock'].freeze
      BOARD_SIZE = 12
      WINNING_SCORE = 6

      def initialize
        @players = []
        @places = []
        @purses = []
        @in_penalty_box = []
        @questions = Hash.new { |h, k| h[k] = [] }
        @current_player = 0
        @is_getting_out_of_penalty_box = false

        50.times do |i|
          CATEGORIES.each { |cat| @questions[cat] << "#{cat} Question #{i}" }
        end
      end

      def is_playable?
        @players.size >= 2
      end

      def add(player_name)
        @players << player_name
        @places << 0
        @purses << 0
        @in_penalty_box << false

        puts "#{player_name} was added"
        puts "They are player number #{@players.size}"
        true
      end

      def how_many_players
        @players.size
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

        puts "Answer was correct!!!!"
        @purses[@current_player] += 1
        puts "#{current_player_name} now has #{@purses[@current_player]} Gold Coins."

        winner = !did_player_win?
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
        @places[@current_player] = (@places[@current_player] + roll) % BOARD_SIZE
        puts "#{current_player_name}'s new location is #{@places[@current_player]}"
        puts "The category is #{current_category}"
      end

      def ask_question
        puts @questions[current_category].shift
      end

      def current_category
        CATEGORIES[@places[@current_player] % CATEGORIES.size]
      end

      def advance_player
        @current_player = (@current_player + 1) % @players.size
      end

      def did_player_win?
        @purses[@current_player] == WINNING_SCORE
      end
    end
  end
end
